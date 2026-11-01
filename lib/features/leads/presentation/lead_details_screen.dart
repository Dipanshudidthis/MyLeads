import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/lead_status.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';
import '../../calling/services/external_action_launcher.dart';

final _leadStreamProvider =
    StreamProvider.family<Lead?, String>((ref, id) {
  return ref.watch(leadRepositoryProvider).watchById(id);
});


/// Full details, editing, history, and actions for a single lead.
class LeadDetailsScreen extends ConsumerWidget {
  const LeadDetailsScreen({super.key, required this.leadId});

  final String leadId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadAsync = ref.watch(_leadStreamProvider(leadId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: leadAsync.when(
        data: (lead) {
          if (lead == null) {
            return const Center(child: Text('This lead no longer exists'));
          }
          return _LeadDetailsBody(lead: lead);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load this lead')),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Lead?'),
        content: const Text('This lead and its call history will be permanently deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(leadRepositoryProvider).deleteLead(leadId);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

class _LeadDetailsBody extends ConsumerWidget {
  const _LeadDetailsBody({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = LeadStatus.fromDb(lead.status);
    final dateFormat = DateFormat('d MMM yyyy, h:mm a');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lead.name?.isNotEmpty == true ? lead.name! : 'Unknown Contact',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _editLead(context, ref),
                    ),
                  ],
                ),
                Text(lead.phoneNumber, style: Theme.of(context).textTheme.bodyLarge),
                if (lead.company?.isNotEmpty == true) Text(lead.company!),
                if (lead.email?.isNotEmpty == true) Text(lead.email!),
                const SizedBox(height: 12),
                DropdownButton<LeadStatus>(
                  value: status,
                  items: LeadStatus.values
                      .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                      .toList(),
                  onChanged: (s) {
                    if (s != null) {
                      ref.read(leadRepositoryProvider).updateLead(lead.id, status: s);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => ExternalActionLauncher.callNumber(lead.normalizedPhoneNumber),
                icon: const Icon(Icons.call_outlined),
                label: const Text('Call'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final result =
                      await ExternalActionLauncher.openWhatsApp(lead.normalizedPhoneNumber);
                  if (result != LaunchResult.success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('WhatsApp is not available on this device.')),
                    );
                  }
                },
                icon: const Icon(Icons.chat_outlined),
                label: const Text('WhatsApp'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy_outlined),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: lead.phoneNumber));
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Phone number copied')));
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Follow-up', style: Theme.of(context).textTheme.titleMedium),
                    TextButton(
                      onPressed: () => _scheduleFollowUp(context, ref),
                      child: Text(lead.nextFollowUpAt != null ? 'Change' : 'Schedule'),
                    ),
                  ],
                ),
                if (lead.nextFollowUpAt != null)
                  Row(
                    children: [
                      Expanded(child: Text(dateFormat.format(lead.nextFollowUpAt!))),
                      TextButton(
                        onPressed: () => _cancelFollowUp(ref),
                        child: const Text('Cancel'),
                      ),
                    ],
                  )
                else
                  const Text('No follow-up scheduled'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notes', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(lead.notes?.isNotEmpty == true ? lead.notes! : 'No notes yet'),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _editNotes(context, ref),
                    child: const Text('Edit Notes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _editLead(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController(text: lead.name);
    final phoneCtrl = TextEditingController(text: lead.phoneNumber);
    final companyCtrl = TextEditingController(text: lead.company);
    final emailCtrl = TextEditingController(text: lead.email);

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Lead'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
              TextField(controller: companyCtrl, decoration: const InputDecoration(labelText: 'Company')),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Save')),
        ],
      ),
    );

    if (saved == true) {
      await ref.read(leadRepositoryProvider).updateLead(
            lead.id,
            name: nameCtrl.text.trim(),
            phoneNumber: phoneCtrl.text.trim(),
            company: companyCtrl.text.trim(),
            email: emailCtrl.text.trim(),
          );
    }
  }

  Future<void> _editNotes(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(text: lead.notes);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Notes'),
        content: TextField(controller: ctrl, maxLines: 5),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Save')),
        ],
      ),
    );
    if (saved == true) {
      await ref.read(leadRepositoryProvider).updateLead(lead.id, notes: ctrl.text.trim());
    }
  }

  Future<void> _scheduleFollowUp(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: lead.nextFollowUpAt ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null || !context.mounted) return;
    
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(lead.nextFollowUpAt ?? DateTime.now()),
    );
    if (time == null) return;

    final when = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    await ref.read(leadRepositoryProvider).setFollowUp(lead.id, when);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Follow-up scheduled for ${DateFormat('d MMM yyyy, h:mm a').format(when)}',
          ),
        ),
      );
    }
  }

  Future<void> _cancelFollowUp(WidgetRef ref) async {
    await ref.read(leadRepositoryProvider).setFollowUp(lead.id, null);
  }
}

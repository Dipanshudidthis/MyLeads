import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/lead_repository.dart';
import '../providers/import_review_provider.dart';

/// Review, edit, and confirm extracted records before saving them.
///
/// Nothing is written to the database until the user explicitly confirms.
class ImportReviewScreen extends ConsumerStatefulWidget {
  const ImportReviewScreen({super.key, this.targetListId});

  final String? targetListId;

  @override
  ConsumerState<ImportReviewScreen> createState() =>
      _ImportReviewScreenState();
}

class _ImportReviewScreenState extends ConsumerState<ImportReviewScreen> {
  String? _selectedListId;
  final _newListController = TextEditingController();
  bool _creatingNewList = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedListId = widget.targetListId;
    _creatingNewList = widget.targetListId == null;
  }

  @override
  void dispose() {
    _newListController.dispose();
    super.dispose();
  }

  Future<void> _refreshDuplicatesForSelectedList() async {
    if (_selectedListId == null) return;
    final existing = await ref
        .read(leadRepositoryProvider)
        .existingNormalizedNumbers(_selectedListId!);
    ref.read(importReviewProvider.notifier).markDuplicatesAgainst(existing);
  }

  Future<void> _confirm() async {
    final entries =
        ref.read(importReviewProvider).where((e) => e.included).toList();
    if (entries.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No entries selected')));
      return;
    }

    setState(() => _saving = true);
    try {
      String listId;
      if (_creatingNewList) {
        final name = _newListController.text.trim();
        if (name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter a name for the new list')),
          );
          setState(() => _saving = false);
          return;
        }
        final list =
            await ref.read(leadListRepositoryProvider).createList(name);
        listId = list.id;
      } else {
        if (_selectedListId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Choose a list to save into')),
          );
          setState(() => _saving = false);
          return;
        }
        listId = _selectedListId!;
      }

      final inputs = entries
          .map((e) => NewLeadInput(
                name: e.name,
                phoneNumber: e.phone,
                normalizedPhoneNumber: e.normalized,
              ))
          .toList();

      final count =
          await ref.read(leadRepositoryProvider).insertMany(listId, inputs);

      if (!mounted) return;
      ref.read(importReviewProvider.notifier).clear();
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import completed: $count leads added.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save this list. Your existing data has not been changed.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(importReviewProvider);
    final total = entries.length;
    final plausible = entries.where((e) => e.isPlausible).length;
    final invalid = total - plausible;
    final duplicates = entries.where((e) => e.isDuplicate).length;
    final listsAsync = ref.watch(_allListsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Review Import')),
      body: SafeArea(
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatChip(label: 'Total', value: total),
                _StatChip(label: 'Plausible', value: plausible),
                _StatChip(label: 'Needs review', value: invalid),
                _StatChip(label: 'Duplicates', value: duplicates),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => ref
                      .read(importReviewProvider.notifier)
                      .setAllIncluded(true),
                  child: const Text('Select All'),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(importReviewProvider.notifier)
                      .setAllIncluded(false),
                  child: const Text('Deselect All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text('No entries'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: e.included,
                            onChanged: (v) => ref
                                .read(importReviewProvider.notifier)
                                .setIncluded(e.id, v ?? false),
                          ),
                          title: Text(e.name?.isNotEmpty == true
                              ? e.name!
                              : 'Unknown Contact'),
                          subtitle: Text(
                            e.isDuplicate
                                ? '${e.phone} • Duplicate'
                                : (!e.isPlausible
                                    ? '${e.phone} • Needs review'
                                    : e.normalized),
                            style: TextStyle(
                              color: e.isDuplicate
                                  ? Colors.orange.shade800
                                  : (!e.isPlausible
                                      ? Theme.of(context).colorScheme.error
                                      : null),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _editEntry(context, e.id, e.name, e.phone),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Save to'),
                const SizedBox(height: 8),
                listsAsync.when(
                  data: (lists) => Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _creatingNewList ? null : _selectedListId,
                          hint: const Text('Choose existing list'),
                          items: lists
                              .map((l) => DropdownMenuItem(
                                    value: l.id,
                                    child: Text(l.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedListId = value;
                              _creatingNewList = false;
                            });
                            _refreshDuplicatesForSelectedList();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => setState(() => _creatingNewList = true),
                        child: const Text('New list'),
                      ),
                    ],
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const Text('Could not load lists'),
                ),
                if (_creatingNewList) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newListController,
                    decoration: const InputDecoration(
                      hintText: 'New list name',
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : _confirm,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Save ${entries.where((e) => e.included).length} Leads'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _editEntry(
    BuildContext context,
    String id,
    String? name,
    String phone,
  ) {
    final nameController = TextEditingController(text: name);
    final phoneController = TextEditingController(text: phone);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(importReviewProvider.notifier).updateEntry(
                    id,
                    name: nameController.text,
                    phone: phoneController.text,
                  );
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

final _allListsProvider = StreamProvider<List<LeadList>>((ref) {
  return ref.watch(leadListRepositoryProvider).watchAll();
});

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}

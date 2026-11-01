import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/lead_status.dart';
import '../../../data/database/app_database.dart';
import '../../leads/providers/leads_providers.dart';
import '../services/external_action_launcher.dart';

/// One-lead-at-a-time calling experience for a list, with outcome capture
/// and persisted session progress.
class CallingWorkspaceScreen extends ConsumerStatefulWidget {
  const CallingWorkspaceScreen({super.key, required this.list});

  final LeadList list;

  @override
  ConsumerState<CallingWorkspaceScreen> createState() =>
      _CallingWorkspaceScreenState();
}

class _CallingWorkspaceScreenState extends ConsumerState<CallingWorkspaceScreen>
    with WidgetsBindingObserver {
  int _index = 0;
  bool _restored = false;

  String get _sessionKey => 'calling_session_index_${widget.list.id}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restoreSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _index = prefs.getInt(_sessionKey) ?? 0;
        _restored = true;
      });
    }
  }

  Future<void> _persistIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, index);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App resumed from call/WhatsApp - no need to record outcome anymore
  }

  @override
  Widget build(BuildContext context) {
    final leadsAsync = ref.watch(leadsForListProvider(widget.list.id));

    return Scaffold(
      appBar: AppBar(title: Text('Calling: ${widget.list.name}')),
      body: SafeArea(
        child: !_restored
            ? const Center(child: CircularProgressIndicator())
            : leadsAsync.when(
                data: (leads) {
                  if (leads.isEmpty) {
                    return const Center(child: Text('No leads in this list yet'));
                  }
                  final sorted = List<Lead>.from(leads)
                    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  final clampedIndex = _index.clamp(0, sorted.length - 1);
                  final lead = sorted[clampedIndex];

                  return _CallingBody(
                    lead: lead,
                    index: clampedIndex,
                    total: sorted.length,
                    onCall: () => _onCall(lead),
                    onWhatsApp: () => _onWhatsApp(lead),
                    onSkip: () => _move(sorted, clampedIndex, 1),
                    onPrevious: clampedIndex > 0
                        ? () => _move(sorted, clampedIndex, -1)
                        : null,
                    onNext: clampedIndex < sorted.length - 1
                        ? () => _move(sorted, clampedIndex, 1)
                        : null,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const Center(child: Text('Could not load leads')),
              ),
      ),
    );
  }

  void _move(List<Lead> sorted, int current, int delta) {
    final next = (current + delta).clamp(0, sorted.length - 1);
    setState(() => _index = next);
    _persistIndex(next);
  }

  Future<void> _onCall(Lead lead) async {
    await ExternalActionLauncher.callNumber(lead.normalizedPhoneNumber);
  }

  Future<void> _onWhatsApp(Lead lead) async {
    final result = await ExternalActionLauncher.openWhatsApp(lead.normalizedPhoneNumber);
    if (result != LaunchResult.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp is not available on this device.')),
      );
    }
  }
}

class _CallingBody extends StatelessWidget {
  const _CallingBody({
    required this.lead,
    required this.index,
    required this.total,
    required this.onCall,
    required this.onWhatsApp,
    required this.onSkip,
    required this.onPrevious,
    required this.onNext,
  });

  final Lead lead;
  final int index;
  final int total;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onSkip;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final status = LeadStatus.fromDb(lead.status);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('${index + 1} of $total', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: total == 0 ? 0 : (index + 1) / total),
          const Spacer(),
          Text(
            lead.name?.isNotEmpty == true ? lead.name! : 'Unknown Contact',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(lead.phoneNumber, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Chip(label: Text(status.label)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: onCall,
                icon: const Icon(Icons.call),
                label: const Text('Call'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onWhatsApp,
                icon: const Icon(Icons.chat),
                label: const Text('WhatsApp'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: onPrevious,
                icon: const Icon(Icons.chevron_left),
                label: const Text('Previous'),
              ),
              TextButton(onPressed: onSkip, child: const Text('Skip')),
              TextButton.icon(
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right),
                label: const Text('Next'),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

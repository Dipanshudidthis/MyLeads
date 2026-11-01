import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/lead_status.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';
import '../../calling/presentation/calling_workspace_screen.dart';
import '../../import_leads/presentation/import_hub_screen.dart';
import '../../lead_lists/presentation/lead_lists_screen.dart';
import '../../leads/presentation/all_leads_screen.dart';
import '../../leads/presentation/lead_list_workspace_screen.dart';
import '../../settings/providers/first_launch_provider.dart';

/// Watches every lead across all lists. This is the single source of truth
/// for dashboard stats, so they stay correct after imports, status changes,
/// and list deletions (including cascaded lead deletions).
final _allLeadsProvider = StreamProvider<List<Lead>>((ref) {
  return ref.watch(leadRepositoryProvider).watchAll();
});

/// Home dashboard with real, locally derived statistics.
class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSeenNotice = ref.watch(firstLaunchProvider);
    
    // Show data protection notice on first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasSeenNotice) {
        _showDataProtectionNotice(context, ref);
      }
    });

    final listsAsync = ref.watch(leadListsStreamProvider);
    final allLeadsAsync = ref.watch(_allLeadsProvider);
    final leads = allLeadsAsync.value ?? const <Lead>[];

    final total = leads.length;
    final uncontacted =
        leads.where((l) => LeadStatus.fromDb(l.status) == LeadStatus.newLead).length;
    final interested =
        leads.where((l) => LeadStatus.fromDb(l.status) == LeadStatus.interested).length;
    final endOfToday = DateTime.now();

    bool isFollowUpToday(Lead l) =>
        l.nextFollowUpAt != null &&
        !l.nextFollowUpAt!.isAfter(
          DateTime(endOfToday.year, endOfToday.month, endOfToday.day, 23, 59, 59),
        );

    final followUpsToday = leads.where(isFollowUpToday).length;

    void openAllLeads(String title, bool Function(Lead) filter) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AllLeadsScreen(title: title, filter: filter),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('MyLeads')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(_allLeadsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Welcome back', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ImportHubScreen()),
                    ),
                    icon: const Icon(Icons.file_download_outlined),
                    label: const Text('Import Leads'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LeadListsScreen()),
                    ),
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text('Create List'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _StatCard(
                  label: 'Total Leads',
                  value: total,
                  onTap: () => openAllLeads('All Leads', (_) => true),
                ),
                _StatCard(
                  label: 'Uncontacted',
                  value: uncontacted,
                  onTap: () => openAllLeads(
                    'Uncontacted Leads',
                    (l) => LeadStatus.fromDb(l.status) == LeadStatus.newLead,
                  ),
                ),
                _StatCard(
                  label: 'Interested',
                  value: interested,
                  onTap: () => openAllLeads(
                    'Interested Leads',
                    (l) => LeadStatus.fromDb(l.status) == LeadStatus.interested,
                  ),
                ),
                _StatCard(
                  label: 'Follow-ups Today',
                  value: followUpsToday,
                  onTap: () => openAllLeads('Follow-ups Today', isFollowUpToday),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Your Lists', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            listsAsync.when(
              data: (lists) {
                if (lists.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            "You don't have any lists yet. Import a batch of "
                            'numbers to get started.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ImportHubScreen()),
                            ),
                            child: const Text('Import Leads'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final recent = lists.take(5).toList();
                return Column(
                  children: recent
                      .map((l) => Card(
                            child: ListTile(
                              title: Text(l.name),
                              trailing: TextButton(
                                child: const Text('Call'),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CallingWorkspaceScreen(list: l),
                                  ),
                                ),
                              ),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LeadListWorkspaceScreen(list: l),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Text('Could not load lists'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.onTap});

  final String label;
  final int value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$value', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

void _showDataProtectionNotice(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('📱 Your Data is Protected'),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your leads and follow-ups are stored locally on this phone. '
              'They will survive an uninstall/reinstall if:',
            ),
            SizedBox(height: 12),
            Text(
              '✓ Android Auto Backup is enabled in your Google settings, OR',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              '✓ You manually export your data from Settings → Export',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Text(
              'Without one of these, reinstalling the app will lose all data.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.orange),
            ),
            SizedBox(height: 12),
            Text(
              'Recommendation: Export your data monthly to a cloud service (Google Drive, OneDrive, Dropbox) for permanent safety.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Got it, I understand'),
        ),
      ],
    ),
  ).then((_) {
    ref.read(firstLaunchProvider.notifier).markAsSeen();
  });
}


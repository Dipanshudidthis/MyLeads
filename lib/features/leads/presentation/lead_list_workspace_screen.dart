import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../calling/presentation/calling_workspace_screen.dart';
import '../../import_leads/presentation/import_hub_screen.dart';
import '../providers/leads_providers.dart';
import 'widgets/lead_row.dart';

/// Fast, searchable workspace for a single lead list.
class LeadListWorkspaceScreen extends ConsumerWidget {
  const LeadListWorkspaceScreen({super.key, required this.list});

  final LeadList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsAsync = ref.watch(leadsForListProvider(list.id));
    final filter = ref.watch(leadListFilterProvider);

    return Scaffold(
      appBar: AppBar(title: Text(list.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImportHubScreen(targetListId: list.id),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Leads'),
      ),
      body: SafeArea(
        child: leadsAsync.when(
          data: (leads) {
            final filtered = applyLeadFilters(leads, filter);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Search name or number',
                    ),
                    onChanged: (v) =>
                        ref.read(leadListFilterProvider.notifier).setSearch(v),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('Uncontacted'),
                          selected: filter.onlyUncontacted,
                          onSelected: (v) => ref
                              .read(leadListFilterProvider.notifier)
                              .toggleUncontacted(v),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Needs follow-up'),
                          selected: filter.onlyNeedsFollowUp,
                          onSelected: (v) => ref
                              .read(leadListFilterProvider.notifier)
                              .toggleNeedsFollowUp(v),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          avatar: const Icon(Icons.sort_rounded, size: 18),
                          label: const Text('Sort'),
                          onPressed: () => _showSortSheet(context, ref),
                        ),
                      ],
                    ),
                  ),
                ),
                if (leads.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CallingWorkspaceScreen(list: list),
                          ),
                        ),
                        icon: const Icon(Icons.call_outlined),
                        label: const Text('Start Calling'),
                      ),
                    ),
                  ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('No leads match your filters'))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) =>
                              LeadRow(lead: filtered[index]),
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('Could not load leads')),
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Newest first'),
              onTap: () {
                ref.read(leadListFilterProvider.notifier).setSort(LeadSort.createdDesc);
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              title: const Text('Name (A-Z)'),
              onTap: () {
                ref.read(leadListFilterProvider.notifier).setSort(LeadSort.nameAsc);
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              title: const Text('Next follow-up'),
              onTap: () {
                ref.read(leadListFilterProvider.notifier).setSort(LeadSort.nextFollowUp);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

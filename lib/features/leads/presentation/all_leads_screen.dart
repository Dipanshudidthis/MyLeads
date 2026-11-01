import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';
import 'widgets/lead_row.dart';

final _allLeadsStreamProvider = StreamProvider<List<Lead>>((ref) {
  return ref.watch(leadRepositoryProvider).watchAll();
});

/// Shows every lead across all lists that matches [filter], used to drill
/// into the Home dashboard's stat cards (Total, Uncontacted, Interested,
/// Follow-ups Today).
class AllLeadsScreen extends ConsumerWidget {
  const AllLeadsScreen({
    super.key,
    required this.title,
    required this.filter,
  });

  final String title;
  final bool Function(Lead lead) filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsAsync = ref.watch(_allLeadsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: leadsAsync.when(
          data: (leads) {
            final filtered = leads.where(filter).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            if (filtered.isEmpty) {
              return const Center(child: Text('No leads match this filter'));
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) => LeadRow(lead: filtered[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('Could not load leads')),
        ),
      ),
    );
  }
}

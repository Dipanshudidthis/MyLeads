import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/lead_status.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';

final leadsForListProvider =
    StreamProvider.family<List<Lead>, String>((ref, listId) {
  return ref.watch(leadRepositoryProvider).watchForList(listId);
});

enum LeadSort { nameAsc, createdDesc, nextFollowUp }

class LeadListFilterState {
  const LeadListFilterState({
    this.searchQuery = '',
    this.statusFilter,
    this.onlyUncontacted = false,
    this.onlyNeedsFollowUp = false,
    this.sort = LeadSort.createdDesc,
  });

  final String searchQuery;
  final LeadStatus? statusFilter;
  final bool onlyUncontacted;
  final bool onlyNeedsFollowUp;
  final LeadSort sort;

  LeadListFilterState copyWith({
    String? searchQuery,
    LeadStatus? Function()? statusFilter,
    bool? onlyUncontacted,
    bool? onlyNeedsFollowUp,
    LeadSort? sort,
  }) {
    return LeadListFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
      onlyUncontacted: onlyUncontacted ?? this.onlyUncontacted,
      onlyNeedsFollowUp: onlyNeedsFollowUp ?? this.onlyNeedsFollowUp,
      sort: sort ?? this.sort,
    );
  }
}

class LeadListFilterNotifier extends Notifier<LeadListFilterState> {
  @override
  LeadListFilterState build() => const LeadListFilterState();

  void setSearch(String query) => state = state.copyWith(searchQuery: query);

  void setStatus(LeadStatus? status) =>
      state = state.copyWith(statusFilter: () => status);

  void toggleUncontacted(bool value) =>
      state = state.copyWith(onlyUncontacted: value);

  void toggleNeedsFollowUp(bool value) =>
      state = state.copyWith(onlyNeedsFollowUp: value);

  void setSort(LeadSort sort) => state = state.copyWith(sort: sort);
}

final leadListFilterProvider =
    NotifierProvider<LeadListFilterNotifier, LeadListFilterState>(
  LeadListFilterNotifier.new,
);

List<Lead> applyLeadFilters(List<Lead> leads, LeadListFilterState filter) {
  var result = leads.where((l) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      final matches = (l.name?.toLowerCase().contains(q) ?? false) ||
          l.phoneNumber.toLowerCase().contains(q) ||
          l.normalizedPhoneNumber.toLowerCase().contains(q) ||
          (l.company?.toLowerCase().contains(q) ?? false);
      if (!matches) return false;
    }
    if (filter.statusFilter != null &&
        LeadStatus.fromDb(l.status) != filter.statusFilter) {
      return false;
    }
    if (filter.onlyUncontacted && LeadStatus.fromDb(l.status) != LeadStatus.newLead) {
      return false;
    }
    if (filter.onlyNeedsFollowUp && l.nextFollowUpAt == null) {
      return false;
    }
    return true;
  }).toList();

  switch (filter.sort) {
    case LeadSort.nameAsc:
      result.sort((a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));
      break;
    case LeadSort.createdDesc:
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case LeadSort.nextFollowUp:
      result.sort((a, b) {
        if (a.nextFollowUpAt == null && b.nextFollowUpAt == null) return 0;
        if (a.nextFollowUpAt == null) return 1;
        if (b.nextFollowUpAt == null) return -1;
        return a.nextFollowUpAt!.compareTo(b.nextFollowUpAt!);
      });
      break;
  }

  return result;
}

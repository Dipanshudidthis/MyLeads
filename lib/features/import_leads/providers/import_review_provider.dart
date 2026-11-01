import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/phone_utils.dart';
import '../models/review_entry.dart';

/// Holds the in-progress, editable list of records for the current import
/// session, until the user confirms or cancels. Nothing is persisted until
/// confirmation.
class ImportReviewNotifier extends Notifier<List<ReviewEntry>> {
  @override
  List<ReviewEntry> build() => [];

  void loadFromExtracted(
    List<ExtractedLeadRecord> records, {
    Set<String> existingNormalizedNumbers = const {},
  }) {
    final seen = <String>{...existingNormalizedNumbers};
    final entries = <ReviewEntry>[];
    for (final r in records) {
      final base = ReviewEntry.fromExtracted(r);
      final isDup = base.isPlausible && seen.contains(base.normalized);
      if (base.isPlausible) seen.add(base.normalized);
      entries.add(base.copyWith(isDuplicate: isDup));
    }
    state = entries;
  }

  void clear() => state = [];

  void updateEntry(String id, {String? name, String? phone}) {
    state = [
      for (final e in state)
        if (e.id == id)
          () {
            final newPhone = phone ?? e.phone;
            final normalization = phone != null
                ? PhoneUtils.normalize(newPhone)
                : PhoneNormalizationResult(
                    normalized: e.normalized,
                    isPlausible: e.isPlausible,
                  );
            return e.copyWith(
              name: name ?? e.name,
              phone: newPhone,
              normalized: normalization.normalized,
              isPlausible: normalization.isPlausible,
            );
          }()
        else
          e,
    ];
  }

  void setIncluded(String id, bool included) {
    state = [
      for (final e in state)
        if (e.id == id) e.copyWith(included: included) else e,
    ];
  }

  void setAllIncluded(bool included) {
    state = [for (final e in state) e.copyWith(included: included)];
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  /// Recomputes duplicate flags against a target list's existing numbers
  /// (plus duplicates within the batch itself) without resetting the batch.
  void markDuplicatesAgainst(Set<String> existingNormalizedNumbers) {
    final seen = <String>{...existingNormalizedNumbers};
    state = [
      for (final e in state)
        if (e.isPlausible)
          e.copyWith(isDuplicate: !seen.add(e.normalized))
        else
          e,
    ];
  }
}

final importReviewProvider =
    NotifierProvider<ImportReviewNotifier, List<ReviewEntry>>(
  ImportReviewNotifier.new,
);

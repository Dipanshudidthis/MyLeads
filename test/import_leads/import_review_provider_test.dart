import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/utils/phone_utils.dart';
import 'package:flutter_application_1/features/import_leads/providers/import_review_provider.dart';

void main() {
  test('flags duplicates within a batch and against existing numbers', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final records = PhoneUtils.extractFromText(
      '9876543210\n9876543210\n9876543211',
    );

    container.read(importReviewProvider.notifier).loadFromExtracted(
          records,
          existingNormalizedNumbers: {'9876543211'},
        );

    final entries = container.read(importReviewProvider);
    expect(entries, hasLength(3));
    expect(entries[0].isDuplicate, isFalse); // first occurrence
    expect(entries[1].isDuplicate, isTrue); // repeated within batch
    expect(entries[2].isDuplicate, isTrue); // already exists in target list
  });

  test('deselecting an entry excludes it without removing it', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final records = PhoneUtils.extractFromText('9876543210');
    container.read(importReviewProvider.notifier).loadFromExtracted(records);

    final id = container.read(importReviewProvider).single.id;
    container.read(importReviewProvider.notifier).setIncluded(id, false);

    final entries = container.read(importReviewProvider);
    expect(entries, hasLength(1));
    expect(entries.single.included, isFalse);
  });
}

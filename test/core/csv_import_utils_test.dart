import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/utils/csv_import_utils.dart';

void main() {
  group('CsvImportUtils.parse', () {
    test('detects a single phone column by header name', () {
      const csv = 'Name,Phone\nRahul,9876543210\nPriya,9876543211';
      final result = CsvImportUtils.parse(csv);
      expect(result.headers, ['Name', 'Phone']);
      expect(result.rows, hasLength(2));
      expect(result.phoneColumnCandidates, [1]);
      expect(result.nameColumnIndex, 0);
      expect(result.hasAmbiguousPhoneColumn, isFalse);
    });

    test('flags ambiguity when multiple phone-like columns exist', () {
      const csv = 'Mobile,Contact\n9876543210,9876543211';
      final result = CsvImportUtils.parse(csv);
      expect(result.hasAmbiguousPhoneColumn, isTrue);
      expect(result.phoneColumnCandidates, [0, 1]);
    });

    test('reports no phone column when none match known headers', () {
      const csv = 'Foo,Bar\n1,2';
      final result = CsvImportUtils.parse(csv);
      expect(result.hasNoPhoneColumn, isTrue);
    });

    test('ignores fully blank rows', () {
      const csv = 'Name,Phone\nRahul,9876543210\n,\n';
      final result = CsvImportUtils.parse(csv);
      expect(result.rows, hasLength(1));
    });
  });

  group('CsvImportUtils.buildCsv', () {
    test('escapes commas and quotes per RFC 4180', () {
      final csv = CsvImportUtils.buildCsv([
        ['Name', 'Notes'],
        ['Rahul, Jr.', 'Said "call later"'],
      ]);
      expect(csv.contains('"Rahul, Jr."'), isTrue);
      expect(csv.contains('"Said ""call later"""'), isTrue);
    });
  });
}

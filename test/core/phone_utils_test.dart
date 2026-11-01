import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/utils/phone_utils.dart';

void main() {
  group('PhoneUtils.normalize', () {
    test('keeps an already international number', () {
      final result = PhoneUtils.normalize('+91 98765 43210');
      expect(result.isPlausible, isTrue);
      expect(result.normalized, '+919876543210');
    });

    test('applies default country code to a 10-digit local number', () {
      final result = PhoneUtils.normalize('9876543210', defaultCountryCode: '91');
      expect(result.isPlausible, isTrue);
      expect(result.normalized, '+919876543210');
    });

    test('strips a single trunk prefix zero before applying country code', () {
      final result = PhoneUtils.normalize('09876543210', defaultCountryCode: '91');
      expect(result.isPlausible, isTrue);
      expect(result.normalized, '+919876543210');
    });

    test('converts 00 prefix to +', () {
      final result = PhoneUtils.normalize('0091 9876543210');
      expect(result.isPlausible, isTrue);
      expect(result.normalized.startsWith('+91'), isTrue);
    });

    test('flags an implausibly short number', () {
      final result = PhoneUtils.normalize('12345');
      expect(result.isPlausible, isFalse);
    });

    test('flags an implausibly long number', () {
      final result = PhoneUtils.normalize('1234567890123456789');
      expect(result.isPlausible, isFalse);
    });

    test('returns not plausible for empty input', () {
      final result = PhoneUtils.normalize('   ');
      expect(result.isPlausible, isFalse);
    });
  });

  group('PhoneUtils.extractFromText', () {
    test('extracts newline-separated name + number pairs', () {
      final records = PhoneUtils.extractFromText(
        'Rahul 9876543210\n9876543211\nPriya, +91 9876543212',
      );
      expect(records.length, 3);
      expect(records[0].name, 'Rahul');
      expect(records[0].rawPhone, '9876543210');
      expect(records[1].name, isNull);
      expect(records[2].name, 'Priya');
    });

    test('handles a "Contact:" label prefix', () {
      final records = PhoneUtils.extractFromText('Contact: 9876543213');
      expect(records, hasLength(1));
      expect(records.single.name, isNull);
    });

    test('handles tab-separated spreadsheet rows', () {
      final records = PhoneUtils.extractFromText('Amit\t9876543214');
      expect(records, hasLength(1));
      expect(records.single.name, 'Amit');
      expect(records.single.rawPhone, '9876543214');
    });

    test('does not treat short unrelated numbers as phone numbers', () {
      final records = PhoneUtils.extractFromText('Invoice #42, Qty: 5');
      expect(records, isEmpty);
    });

    test('ignores blank lines', () {
      final records = PhoneUtils.extractFromText('\n\n9876543210\n\n');
      expect(records, hasLength(1));
    });

    test('associates a name on its own line with the number on the next line', () {
      final records = PhoneUtils.extractFromText(
        'Yogesh Mhase\n95525 18139\n\nSudhakar Jagdale\n9850981881',
      );
      expect(records, hasLength(2));
      expect(records[0].name, 'Yogesh Mhase');
      expect(records[0].normalization.normalized, '9552518139');
      expect(records[1].name, 'Sudhakar Jagdale');
      expect(records[1].normalization.normalized, '9850981881');
    });

    test('handles a name containing a period before the number line', () {
      final records = PhoneUtils.extractFromText('Devi. P\n7025375890');
      expect(records, hasLength(1));
      expect(records.single.name, 'Devi. P');
    });
  });
}

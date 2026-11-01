import 'package:csv/csv.dart';

/// Candidate column header names that likely contain a phone number.
const _phoneHeaderCandidates = [
  'phone',
  'mobile',
  'phone number',
  'mobile number',
  'contact',
  'contact number',
  'number',
];

const _nameHeaderCandidates = ['name', 'contact name', 'full name'];
const _notesHeaderCandidates = ['notes', 'note', 'remarks'];

/// Result of parsing a CSV file's structure before import.
class CsvParseResult {
  CsvParseResult({
    required this.headers,
    required this.rows,
    required this.phoneColumnCandidates,
    this.nameColumnIndex,
    this.notesColumnIndex,
  });

  final List<String> headers;
  final List<List<String>> rows;
  final List<int> phoneColumnCandidates;
  final int? nameColumnIndex;
  final int? notesColumnIndex;

  bool get hasAmbiguousPhoneColumn => phoneColumnCandidates.length > 1;
  bool get hasNoPhoneColumn => phoneColumnCandidates.isEmpty;
}

/// Parses CSV content and attempts to detect which column holds phone
/// numbers, optional name, and optional notes columns.
class CsvImportUtils {
  CsvImportUtils._();

  static CsvParseResult parse(String csvContent) {
    final table = const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
    ).convert(csvContent.replaceAll('\r\n', '\n'));

    if (table.isEmpty) {
      return CsvParseResult(headers: [], rows: [], phoneColumnCandidates: []);
    }

    final headers = table.first.map((e) => e.toString().trim()).toList();
    final rows = table
        .skip(1)
        .map((row) => row.map((e) => e.toString()).toList())
        .where((row) => row.any((cell) => cell.trim().isNotEmpty))
        .toList();

    final lowerHeaders = headers.map((h) => h.toLowerCase().trim()).toList();

    final phoneCandidates = <int>[];
    for (var i = 0; i < lowerHeaders.length; i++) {
      if (_phoneHeaderCandidates.contains(lowerHeaders[i])) {
        phoneCandidates.add(i);
      }
    }

    int? nameIndex;
    for (var i = 0; i < lowerHeaders.length; i++) {
      if (_nameHeaderCandidates.contains(lowerHeaders[i])) {
        nameIndex = i;
        break;
      }
    }

    int? notesIndex;
    for (var i = 0; i < lowerHeaders.length; i++) {
      if (_notesHeaderCandidates.contains(lowerHeaders[i])) {
        notesIndex = i;
        break;
      }
    }

    return CsvParseResult(
      headers: headers,
      rows: rows,
      phoneColumnCandidates: phoneCandidates,
      nameColumnIndex: nameIndex,
      notesColumnIndex: notesIndex,
    );
  }

  /// Builds a CSV string from leads, escaping values per RFC 4180.
  static String buildCsv(List<List<String>> rows) {
    return const ListToCsvConverter(eol: '\n').convert(rows);
  }
}

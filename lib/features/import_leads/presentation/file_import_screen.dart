import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/csv_import_utils.dart';
import '../../../core/utils/phone_utils.dart';
import '../../settings/providers/settings_providers.dart';
import '../providers/import_review_provider.dart';
import 'import_review_screen.dart';

/// Import leads from a CSV spreadsheet, detecting the phone number column
/// by its header name.
class FileImportScreen extends ConsumerStatefulWidget {
  const FileImportScreen({super.key, this.targetListId});

  final String? targetListId;

  @override
  ConsumerState<FileImportScreen> createState() => _FileImportScreenState();
}

class _FileImportScreenState extends ConsumerState<FileImportScreen> {
  bool _loading = false;
  String? _error;
  CsvParseResult? _parsed;
  int? _chosenPhoneColumn;

  Future<void> _pickFile() async {
    setState(() {
      _error = null;
      _parsed = null;
      _chosenPhoneColumn = null;
      _loading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        setState(() => _loading = false);
        return;
      }

      final bytes = result.files.single.bytes;
      if (bytes == null) {
        setState(() {
          _error = 'Could not read this file';
          _loading = false;
        });
        return;
      }

      final content = utf8.decode(bytes, allowMalformed: true);
      final parsed = CsvImportUtils.parse(content);

      if (parsed.headers.isEmpty || parsed.rows.isEmpty) {
        setState(() {
          _error = 'This file does not contain any readable rows';
          _loading = false;
        });
        return;
      }

      if (parsed.hasNoPhoneColumn) {
        setState(() {
          _error =
              'This file does not contain a recognizable phone-number column.';
          _parsed = parsed;
          _loading = false;
        });
        return;
      }

      setState(() {
        _parsed = parsed;
        _chosenPhoneColumn = parsed.hasAmbiguousPhoneColumn
            ? null
            : parsed.phoneColumnCandidates.single;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = 'Could not parse this file as CSV';
        _loading = false;
      });
    }
  }

  void _proceed() {
    final parsed = _parsed;
    final phoneCol = _chosenPhoneColumn;
    if (parsed == null || phoneCol == null) return;

    final countryCode = ref.read(defaultCountryCodeProvider);
    final records = <ExtractedLeadRecord>[];

    for (final row in parsed.rows) {
      if (phoneCol >= row.length) continue;
      final rawPhone = row[phoneCol].trim();
      if (rawPhone.isEmpty) continue;

      final name = parsed.nameColumnIndex != null &&
              parsed.nameColumnIndex! < row.length
          ? row[parsed.nameColumnIndex!].trim()
          : null;

      records.add(
        ExtractedLeadRecord(
          rawText: row.join(', '),
          name: (name != null && name.isNotEmpty) ? name : null,
          rawPhone: rawPhone,
          normalization:
              PhoneUtils.normalize(rawPhone, defaultCountryCode: countryCode),
        ),
      );
    }

    if (records.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone numbers found in this file')),
      );
      return;
    }

    ref.read(importReviewProvider.notifier).loadFromExtracted(records);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImportReviewScreen(targetListId: widget.targetListId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parsed = _parsed;
    return Scaffold(
      appBar: AppBar(title: const Text('Import a File')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Supports CSV files with a header row.'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loading ? null : _pickFile,
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('Choose CSV File'),
            ),
            if (_loading) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            if (parsed != null && parsed.hasAmbiguousPhoneColumn) ...[
              const SizedBox(height: 16),
              const Text('Multiple columns could contain phone numbers. Choose one:'),
              const SizedBox(height: 8),
              ...parsed.phoneColumnCandidates.map(
                (i) => RadioListTile<int>(
                  value: i,
                  groupValue: _chosenPhoneColumn,
                  title: Text(parsed.headers[i]),
                  onChanged: (v) => setState(() => _chosenPhoneColumn = v),
                ),
              ),
            ],
            if (parsed != null && !parsed.hasNoPhoneColumn) ...[
              const SizedBox(height: 16),
              Text('${parsed.rows.length} rows detected'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _chosenPhoneColumn != null ? _proceed : null,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

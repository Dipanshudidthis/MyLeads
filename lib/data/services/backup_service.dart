import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/csv_import_utils.dart';
import '../database/app_database.dart';

/// Exports and imports a full local backup as JSON, and lead lists as CSV.
///
/// Backups never leave the device unless the user explicitly shares the
/// exported file.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  Future<Map<String, dynamic>> _buildBackupJson() async {
    final lists = await _db.select(_db.leadLists).get();
    final leads = await _db.select(_db.leads).get();

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'leadLists': lists.map((l) => l.toJson()).toList(),
      'leads': leads.map((l) => l.toJson()).toList(),
    };
  }

  /// Writes a full backup to the app's documents directory and returns the
  /// file path, so the caller can offer to share it.
  Future<File> exportBackupToFile() async {
    final json = await _buildBackupJson();
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/leadflow_backup_${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(json));
    return file;
  }

  /// Encodes a full backup as UTF-8 JSON bytes, for writing directly to a
  /// user-chosen location (e.g. via a save-file dialog) rather than the
  /// app's private storage.
  Future<Uint8List> buildBackupBytes() async {
    final json = await _buildBackupJson();
    return Uint8List.fromList(
      utf8.encode(const JsonEncoder.withIndent('  ').convert(json)),
    );
  }

  /// Validates and previews a backup file's contents without writing
  /// anything. Returns null if the file is not a recognizable backup.
  Future<Map<String, dynamic>?> validateBackupFile(String path) async {
    try {
      final content = await File(path).readAsString();
      final decoded = jsonDecode(content);
      if (decoded is! Map<String, dynamic>) return null;
      if (decoded['leadLists'] is! List || decoded['leads'] is! List) {
        return null;
      }
      return decoded;
    } catch (_) {
      return null;
    }
  }

  /// Restores a previously validated backup. This replaces all existing
  /// data in a single transaction - callers must confirm with the user
  /// first, since this cannot be undone.
  Future<void> restoreFromBackup(Map<String, dynamic> backup) async {
    await _db.transaction(() async {
      await _db.delete(_db.leads).go();
      await _db.delete(_db.leadLists).go();

      for (final raw in backup['leadLists'] as List) {
        await _db.into(_db.leadLists).insert(
              LeadList.fromJson(Map<String, dynamic>.from(raw as Map)),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final raw in backup['leads'] as List) {
        await _db.into(_db.leads).insert(
              Lead.fromJson(Map<String, dynamic>.from(raw as Map)),
              mode: InsertMode.insertOrReplace,
            );
      }
    });
  }

  Future<void> clearAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.leads).go();
      await _db.delete(_db.leadLists).go();
    });
  }

  /// Exports a single list's leads to a CSV file and returns its path.
  Future<File> exportListToCsv(String listId, String listName) async {
    final leads = await (_db.select(_db.leads)..where((t) => t.listId.equals(listId))).get();
    final rows = <List<String>>[
      ['Name', 'Phone', 'Company', 'Email', 'Status', 'Notes'],
      for (final l in leads)
        [
          l.name ?? '',
          l.phoneNumber,
          l.company ?? '',
          l.email ?? '',
          l.status,
          l.notes ?? '',
        ],
    ];
    final csv = CsvImportUtils.buildCsv(rows);
    final dir = await getApplicationDocumentsDirectory();
    final safeName = listName.replaceAll(RegExp(r'[^A-Za-z0-9_\- ]'), '_');
    final file = File('${dir.path}/$safeName.csv');
    await file.writeAsString(csv);
    return file;
  }

  static Future<String?> pickBackupFilePath() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    return result?.files.single.path;
  }
}

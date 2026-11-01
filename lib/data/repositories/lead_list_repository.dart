import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

const _uuid = Uuid();

/// Data-access layer for [LeadLists]. Keeps Drift query code out of the UI.
class LeadListRepository {
  LeadListRepository(this._db);

  final AppDatabase _db;

  Stream<List<LeadList>> watchAll() {
    return (_db.select(
      _db.leadLists,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();
  }

  Future<LeadList?> getById(String id) {
    return (_db.select(
      _db.leadLists,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<bool> nameExists(String name, {String? excludingId}) async {
    final query = _db.select(_db.leadLists)
      ..where((t) => t.name.equals(name.trim()));
    final matches = await query.get();
    return matches.any((l) => l.id != excludingId);
  }

  Future<LeadList> createList(String name, {String? colorHex}) async {
    final now = DateTime.now();
    final entry = LeadListsCompanion.insert(
      id: _uuid.v4(),
      name: name.trim(),
      colorHex: Value(colorHex),
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.leadLists).insert(entry);
    return (await getById(entry.id.value))!;
  }

  Future<void> renameList(String id, String newName) async {
    await (_db.update(_db.leadLists)..where((t) => t.id.equals(id))).write(
      LeadListsCompanion(name: Value(newName.trim()), updatedAt: Value(DateTime.now())),
    );
  }

  /// Deletes a list and all of its leads (cascade) and their call history.
  Future<void> deleteList(String id) async {
    await (_db.delete(_db.leadLists)..where((t) => t.id.equals(id))).go();
  }

  Future<void> touch(String id) async {
    await (_db.update(_db.leadLists)..where((t) => t.id.equals(id))).write(
      LeadListsCompanion(updatedAt: Value(DateTime.now())),
    );
  }
}

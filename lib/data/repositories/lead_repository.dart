import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/lead_status.dart';
import '../database/app_database.dart';

const _uuid = Uuid();

/// A lead to be inserted, prior to getting a stable ID or timestamps.
class NewLeadInput {
  NewLeadInput({
    required this.name,
    required this.phoneNumber,
    required this.normalizedPhoneNumber,
    this.company,
    this.email,
    this.notes,
  });

  final String? name;
  final String phoneNumber;
  final String normalizedPhoneNumber;
  final String? company;
  final String? email;
  final String? notes;
}

/// Data-access layer for [Leads].
class LeadRepository {
  LeadRepository(this._db);

  final AppDatabase _db;

  Stream<List<Lead>> watchForList(String listId) {
    return (_db.select(_db.leads)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Watches every lead across all lists, used to keep dashboard stats
  /// reactive to status changes, imports, and deletions.
  Stream<List<Lead>> watchAll() {
    return _db.select(_db.leads).watch();
  }

  Future<List<Lead>> getForList(String listId) {
    return (_db.select(_db.leads)..where((t) => t.listId.equals(listId))).get();
  }

  Future<Lead?> getById(String id) {
    return (_db.select(_db.leads)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<Lead?> watchById(String id) {
    return (_db.select(_db.leads)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Existing normalized phone numbers for a list, used for duplicate checks.
  Future<Set<String>> existingNormalizedNumbers(String listId) async {
    final leads = await getForList(listId);
    return leads.map((l) => l.normalizedPhoneNumber).toSet();
  }

  /// Inserts many leads for [listId] in a single transaction. If any part
  /// fails, nothing is persisted.
  Future<int> insertMany(String listId, List<NewLeadInput> inputs) async {
    var inserted = 0;
    await _db.transaction(() async {
      final now = DateTime.now();
      for (final input in inputs) {
        await _db.into(_db.leads).insert(
              LeadsCompanion.insert(
                id: _uuid.v4(),
                listId: listId,
                name: Value(input.name),
                phoneNumber: input.phoneNumber,
                normalizedPhoneNumber: input.normalizedPhoneNumber,
                company: Value(input.company),
                email: Value(input.email),
                notes: Value(input.notes),
                createdAt: now,
                updatedAt: now,
              ),
            );
        inserted++;
      }
      await (_db.update(_db.leadLists)..where((t) => t.id.equals(listId))).write(
        LeadListsCompanion(updatedAt: Value(now)),
      );
    });
    return inserted;
  }

  Future<void> updateLead(
    String id, {
    String? name,
    String? phoneNumber,
    String? normalizedPhoneNumber,
    String? company,
    String? email,
    String? notes,
    LeadStatus? status,
  }) async {
    await (_db.update(_db.leads)..where((t) => t.id.equals(id))).write(
      LeadsCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        phoneNumber:
            phoneNumber != null ? Value(phoneNumber) : const Value.absent(),
        normalizedPhoneNumber: normalizedPhoneNumber != null
            ? Value(normalizedPhoneNumber)
            : const Value.absent(),
        company: company != null ? Value(company) : const Value.absent(),
        email: email != null ? Value(email) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
        status: status != null ? Value(status.dbValue) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setFollowUp(
    String leadId,
    DateTime? followUpAt, {
    int? notificationId,
  }) async {
    await (_db.update(_db.leads)..where((t) => t.id.equals(leadId))).write(
      LeadsCompanion(
        nextFollowUpAt: Value(followUpAt),
        notificationId: Value(notificationId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteLead(String id) async {
    await (_db.delete(_db.leads)..where((t) => t.id.equals(id))).go();
  }

  // ---- Dashboard / aggregate queries ----

  Future<int> countAll() async {
    final count = _db.leads.id.count();
    final query = _db.selectOnly(_db.leads)..addColumns([count]);
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> countByStatus(LeadStatus status) async {
    final count = _db.leads.id.count();
    final query = _db.selectOnly(_db.leads)
      ..addColumns([count])
      ..where(_db.leads.status.equals(status.dbValue));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> countUncontacted() async {
    final count = _db.leads.id.count();
    final query = _db.selectOnly(_db.leads)
      ..addColumns([count])
      ..where(_db.leads.status.equals(LeadStatus.newLead.dbValue));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<List<Lead>> getDueFollowUps({bool todayOnly = false}) async {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final query = _db.select(_db.leads)
      ..where((t) => t.nextFollowUpAt.isNotNull())
      ..where((t) => todayOnly
          ? t.nextFollowUpAt.isSmallerOrEqualValue(endOfDay)
          : t.nextFollowUpAt.isSmallerOrEqualValue(now));
    return query.get();
  }

  Future<List<Lead>> search(
    String query, {
    String? listId,
  }) async {
    final like = '%${query.trim()}%';
    final q = _db.select(_db.leads)
      ..where((t) => listId != null ? t.listId.equals(listId) : const Constant(true))
      ..where((t) =>
          t.name.like(like) |
          t.phoneNumber.like(like) |
          t.normalizedPhoneNumber.like(like) |
          t.company.like(like));
    return q.get();
  }
}

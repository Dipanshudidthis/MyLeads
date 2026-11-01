import 'package:drift/drift.dart';

/// A named collection of leads, e.g. "New Prospects".
class LeadLists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get colorHex => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Lead status values. Kept as plain strings in the DB for simplicity and
/// forward-compatible migrations.
class Leads extends Table {
  TextColumn get id => text()();
  TextColumn get listId =>
      text().references(LeadLists, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().nullable()();
  TextColumn get phoneNumber => text()();
  TextColumn get normalizedPhoneNumber => text()();
  TextColumn get company => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('new'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastContactedAt => dateTime().nullable()();
  DateTimeColumn get nextFollowUpAt => dateTime().nullable()();
  IntColumn get notificationId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

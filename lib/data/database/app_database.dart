import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [LeadLists, Leads])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Allows tests to inject an in-memory executor.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      // SQLite does not enforce foreign keys (and therefore cascading
      // deletes) unless this pragma is turned on for every connection.
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'leadflow.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

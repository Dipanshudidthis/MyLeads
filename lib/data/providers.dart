import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'repositories/lead_list_repository.dart';
import 'repositories/lead_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final leadListRepositoryProvider = Provider<LeadListRepository>((ref) {
  return LeadListRepository(ref.watch(appDatabaseProvider));
});

final leadRepositoryProvider = Provider<LeadRepository>((ref) {
  return LeadRepository(ref.watch(appDatabaseProvider));
});

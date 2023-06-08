import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/services/storage.dart';
import 'package:reward_randomizer/services/storage_sqlite.dart';

final storageProvider = Provider<Storage>((ref) {
  return StorageSqlite();
});

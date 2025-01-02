import 'dart:developer';

import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/auth/persistence_manager.dart';
import 'package:wheels_up_v2/user/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final PocketBase pb;
  final RecordAuthPersistenceManager authPersistenceManager;

  const AuthService(this.pb,
      {this.authPersistenceManager =
          const SecureStoragePersistenceManager(FlutterSecureStorage())});

  Future<User> login(String usernameOrEmail, String password) async {
    try {
      final RecordAuth authRecord = await pb
          .collection('users')
          .authWithPassword(usernameOrEmail, password);
      await authPersistenceManager.save(authRecord);
      return User.fromJson(authRecord.record.toJson());
    } catch (e, stackTrace) {
      log('Error logging in: $usernameOrEmail',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<User?> loadLoggedInUser() async {
    try {
      var authRecord = await authPersistenceManager.get();
      if (authRecord == null) {
        return null;
      }

      _injectRecordAuthIntoPb(authRecord);
      await pb.collection('users').authRefresh();
      final record = pb.authStore.record!;
      return User.fromJson(record.toJson());
    } catch (e, stackTrace) {
      log('Error loading logged in user', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    // Clear the PocketBase AuthStore
    pb.authStore.clear();

    // Clear our authPersistenceManager
    await authPersistenceManager.clear();
  }

  void _injectRecordAuthIntoPb(RecordAuth record) async {
    try {
      pb.authStore.save(record.token, record.record);
    } catch (e, stackTrace) {
      log('Error injecting record auth into pb',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

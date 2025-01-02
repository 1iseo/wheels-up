import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up/models/user.dart';


class AuthService {
  final PocketBase pb;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  User2? _currentUser;

  AuthService({required this.pb});

  Future<void> login(String identifier, String password) async {
    try {
      final response = await pb.collection('users').authWithPassword(
            identifier,
            password,
          );

      if (response.token == "") {
        throw 'Invalid credentials';
      }
      pb.authStore.save(response.token, response.record);
    } catch (e) {
      throw Exception("Error when logging in: $e");
    }
  }

  Future<void> register(CreateUserRequest body) async {
    try {
      await pb.collection('users').create(body: body.toJson());
      await pb.collection('users').authWithPassword(body.email, body.password);
    } catch (e) {
      throw Exception('An error occurred during registration: $e');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    pb.authStore.clear();
    await secureStorage.delete(key: 'pb_data');
  }

  Future<String?> getRole() async {
    User2? user = await getCurrentUser();
    return user?.role;
  }

  Future<User2?> getCurrentUser() async {
    if (pb.authStore.record == null) {
      String? data = await secureStorage.read(key: 'pb_data');
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data);
        final user = User2.fromJson(decoded['model'] as Map<String, dynamic>);
        _currentUser = user;
        RecordModel? record = RecordModel.fromJson(
            decoded["model"] as Map<String, dynamic>? ?? {});
        pb.authStore.save(decoded['token'] as String, record);
        return user;
      }
      return null;
    }

    final user = User2.fromJson(pb.authStore.record!.toJson());
    _currentUser = user;
    return user;
  }
}

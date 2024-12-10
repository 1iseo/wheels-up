import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up/models/user.dart';
import 'package:wheels_up/services/pocketbase.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3333', // Update with your backend URL
    contentType: 'application/json',
  ));

  final _storage = const FlutterSecureStorage();

  Future<String?> login(String identifier, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        if (identifier.contains('@'))
          'email': identifier
        else
          'username': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token']['token'];
        final role = response.data['user']['role'];
        print("ROLE: " + role);
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'user_role', value: role);
        return token;
      }
      return null;
    } on DioException catch (e) {
      print("WHAT");
      if (e.response?.statusCode == 401) {
        throw 'Invalid credentials';
      }
      throw 'An error occurred during login';
    }
  }

  Future<String?> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required String role,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        'username': username,
        'role': role.toLowerCase(),
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'user_role', value: role.toLowerCase());
        return token;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null) {
          throw errors.toString();
        }
      }
      throw 'An error occurred during registration';
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_role');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<String?> getRole() async {
    return await _storage.read(key: 'user_role');
  }
}

class AuthService2 {
  final PocketBase pb;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  User2? _currentUser;

  AuthService2({required this.pb});

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
    if (_currentUser != null) {
      return _currentUser;
    }

    if (pb.authStore.record == null) {
      String? data = await secureStorage.read(key: 'pb_data');
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data);
        final user = User2.fromJson(decoded['model'] as Map<String, dynamic>);
        _currentUser = user;
        return user;
      }
      return null;
    }

    final user = User2.fromJson(pb.authStore.record!.toJson());
    _currentUser = user;
    return user;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3333', // Update with your backend URL
    contentType: 'application/json',
  ));

  final _storage = const FlutterSecureStorage();

  Future<String?> login(String identifier, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        if (identifier.contains('@')) 'email': identifier else 'username': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _storage.write(key: 'auth_token', value: token);
        return token;
      }
      return null;
    } on DioException catch (e) {
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
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}

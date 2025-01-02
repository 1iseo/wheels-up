import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/config/api_config.dart';
import 'package:wheels_up_v2/user/user_model.dart';

class UserRegistrationRequest {
  String password;
  String passwordConfirm;
  String username;
  String fullName;
  String email;
  bool emailVisibility;
  bool verified;
  String role;

  UserRegistrationRequest({
    required this.password,
    required this.passwordConfirm,
    required this.username,
    required this.fullName,
    required this.email,
    this.emailVisibility = true,
    this.verified = false,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'passwordConfirm': passwordConfirm,
      'username': username,
      'fullName': fullName,
      'email': email,
      'emailVisibility': emailVisibility,
      'verified': verified,
      'role': role,
    };
  }

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return UserRegistrationRequest(
      password: json['password'],
      passwordConfirm: json['passwordConfirm'],
      username: json['username'],
      fullName: json['fullName'],
      email: json['email'],
      emailVisibility: json['emailVisibility'],
      verified: json['verified'],
      role: json['role'],
    );
  }
}

class UpdateUser {
  String? password;
  String? passwordConfirm;
  String? oldPassword;
  String? username;
  String? fullName;
  XFile? picture;
  bool? emailVisibility;
  bool? verified;

  UpdateUser({
    this.password,
    this.passwordConfirm,
    this.oldPassword,
    this.username,
    this.fullName,
    this.picture,
    this.emailVisibility,
    this.verified,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (password != null) data['password'] = password;
    if (passwordConfirm != null) data['passwordConfirm'] = passwordConfirm;
    if (oldPassword != null) data['oldPassword'] = oldPassword;
    if (username != null) data['username'] = username;
    if (fullName != null) data['fullName'] = fullName;
    if (emailVisibility != null) data['emailVisibility'] = emailVisibility;
    if (verified != null) data['verified'] = verified;

    return data;
  }
}

class UserService {
  final PocketBase pb;

  UserService(this.pb);

  Future<User?> getUserById(String id) async {
    try {
      final record = await pb.collection('users').getOne(id);
      return User.fromJson(record.toJson());
    } catch (e, stackTrace) {
      log('Error fetching user by ID: $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<User?> createUser(UserRegistrationRequest user) async {
    try {
      final record = await pb.collection('users').create(body: user.toJson());
      return User.fromJson(record.toJson());
    } catch (e, stackTrace) {
      log('Error creating user: ${user.toJson()}',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<User?> updateUser(String id, UpdateUser update) async {
    try {
      final record =
          await pb.collection('users').update(id, body: update.toJson());
      return User.fromJson(record.toJson());
    } catch (e, stackTrace) {
      log('Error updating user with ID: $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<User?> updateCurrentUser(UpdateUser update) async {
    final id = pb.authStore.record!.id;
    try {
      final files = List<http.MultipartFile>.empty(growable: true);
      if (update.picture != null) {
        files.add(
          http.MultipartFile.fromBytes(
            'picture',
            await update.picture!.readAsBytes(),
            filename: update.picture!.name,
          ),
        );
      }
      final record =
          await pb.collection('users').update(id, body: update.toJson(), files: files);
      return User.fromJson(record.toJson());
    } catch (e, stackTrace) {
      log('Error updating user with ID: $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteUserById(String id) async {
    try {
      await pb.collection('users').delete(id);
    } catch (e, stackTrace) {
      log('Error deleting user by ID: $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri getUserProfilePictureUrl(User user, String? size) {
    final baseUri = ApiConfig().pbApiUrl;
    final sz = size != null ? '?thumb=$size' : '';
    return Uri.parse('$baseUri/api/files/users/${user.id}/${user.picture}$sz');
  }
}

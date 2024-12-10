import 'package:flutter/material.dart';
import 'package:wheels_up/models/user.dart';
import 'package:wheels_up/services/user_service.dart';

class ProfileChangeNotifier with ChangeNotifier {
  final UserService _userService;
  User2? _currentUser;

  ProfileChangeNotifier({required UserService userService})
      : _userService = userService;

  User2? get currentUser => _currentUser;

  Future<void> updateProfile(UpdateProfileRequest request) async {
    try {
      final updatedUser = await _userService.updateProfile(request);
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      // Handle the error
      debugPrint('Error updating profile: $e');
    }
  }
}

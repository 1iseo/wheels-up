import 'package:flutter/material.dart';
import 'package:wheels_up/models/user.dart';
import 'package:wheels_up/services/auth_service.dart';

// Only use this provider if we're guaranteed to have a user
class UserDataProvider extends ChangeNotifier {
  final AuthService2 authService;
  late User2? _user;

  UserDataProvider({required this.authService}) {
    // Initialize user data via auth service
    authService.getCurrentUser().then((user) {
      _user = user;  
      notifyListeners();
    });
  }

  User2? get user => _user;

  setCurrentUserData(User2 user) {
    _user = user;
    notifyListeners();
  }
}

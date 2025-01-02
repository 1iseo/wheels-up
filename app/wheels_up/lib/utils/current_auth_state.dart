import 'package:flutter/material.dart';

class CurrentAuthState extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void updateAuthState(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }
}
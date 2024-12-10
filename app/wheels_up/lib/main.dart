import 'package:flutter/material.dart';
import 'package:wheels_up/pages/landing_welcome.dart';
import 'package:wheels_up/pages/main_shell.dart';
import 'package:wheels_up/services/auth_service.dart';

void main() {
  runApp(const AuthWrapper());
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isAuthenticated = false;

  void _handleAuthChanged(bool isAuthenticated) {
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainAppShell2(
        isAuthenticated: _isAuthenticated,
        onAuthenticationUpdate: _handleAuthChanged);
  }
}

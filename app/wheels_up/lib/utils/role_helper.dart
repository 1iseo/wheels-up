import 'package:flutter/material.dart';
import '../services/auth_service.dart';

enum UserRole {
  pemilik,
  penyewa,
  unknown
}

class RoleHelper {
  static final AuthService _authService = AuthService();

  static Future<UserRole> getCurrentRole() async {
    final role = await _authService.getRole();
    print(role ?? "no role");
    switch (role?.toLowerCase()) {
      case 'pemilik':
        return UserRole.pemilik;
      case 'penyewa':
        return UserRole.penyewa;
      default:
        return UserRole.unknown;
    }
  }

  static Widget roleBasedBuilder({
    required Widget Function() pemilikBuilder,
    required Widget Function() penyewaBuilder,
    Widget Function()? unknownBuilder,
  }) {
    return FutureBuilder<UserRole>(
      future: getCurrentRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        switch (snapshot.data) {
          case UserRole.pemilik:
            return pemilikBuilder();
          case UserRole.penyewa:
            return penyewaBuilder();
          default:
            return unknownBuilder?.call() ?? 
                   const Center(child: Text('Unknown role'));
        }
      },
    );
  }
}

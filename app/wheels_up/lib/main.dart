import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/config/api_config.dart';
import 'package:wheels_up/pages/main_shell.dart';
import 'package:wheels_up/services/auth_service.dart';
import 'package:wheels_up/services/car_listing_service.dart';
import 'package:wheels_up/utils/role_helper.dart';

class MyAuthStore extends AuthStore {}

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<PocketBase>(
          create: (_) => PocketBase(ApiConfig.pocketbaseUrl,
              authStore: AsyncAuthStore(save: (String data) async {
            await const FlutterSecureStorage()
                .write(key: 'pb_data', value: data);
          })),
        ),
        Provider<AuthService2>(
          create: (context) => AuthService2(pb: context.read()),
        ),
        Provider<CarListingService>(
          create: (context) => CarListingService(
              pb: context.read(), authService: context.read()),
        ),
        Provider<RoleHelper>(
          create: (context) => RoleHelper(
            authService: context.read(),
          ),
        )
      ],
      child: const AuthWrapper(),
    ),
  );
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final AuthService2 authService;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService2>(context, listen: false);
    loadUser();
  }

  loadUser() async {
    try {
      final user = await authService.getCurrentUser();
      if (user != null) {
        setState(() {
          _isAuthenticated = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR WHEN LOADING USER: $e");
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  void _handleAuthChanged(bool isAuthenticated) {
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : MainAppShell2(
            isAuthenticated: _isAuthenticated,
            onAuthenticationUpdate: _handleAuthChanged);
  }
}

import 'dart:developer';

import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
import 'package:wheels_up_v2/user/user_model.dart';
import 'package:wheels_up_v2/user/user_service.dart';
import 'package:wheels_up_v2/auth/auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final authService = ref.read(authServiceProvider);
    final user = await authService.loadLoggedInUser();

    ref.onDispose(() {
      log('Disposing auth notifier');
    });

    return AuthState(user: user);
  }

  Future<void> replaceUser(User user) async {
    state = AsyncValue.data(AuthState(user: user));
  }

  Future<void> login(String usernameOrEmail, String password) async {
    state = AsyncValue.loading();
    final authService = ref.read(authServiceProvider);

    try {
      await authService.login(usernameOrEmail, password);
      final user = await authService.loadLoggedInUser();
      state = AsyncValue.data(AuthState(user: user));
    } on ClientException catch (err) {
      final serverMsg = err.response["message"];
      throw Exception("Error logging in: $serverMsg");
    }
  }

  Future<void> signUp(UserRegistrationRequest request) async {
    state = AsyncValue.loading();
    final authService = ref.read(authServiceProvider);
    final userService = ref.read(userServiceProvider);

    try {
      // Create the user
      await userService.createUser(request);

      // Authenticate
      await authService.login(request.username, request.password);

      // Make sure we invalidate the auth state
      ref.invalidateSelf();
      await future;
    } on ClientException catch (err) {
      final serverMsg = err.response["message"];
      final errMsg = "Error sign up: $serverMsg";
      throw Exception(errMsg);
    }
  }

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = const AsyncValue.data(AuthState(user: null));
  }
}

// @Riverpod(keepAlive: true)
// class IsAuthenticated extends _$IsAuthenticated {
//   @override
//   bool build() {
//     return false;
//   }

//   updateAuthState(bool isAuthenticated) {
//     state = isAuthenticated;
//   }
// }

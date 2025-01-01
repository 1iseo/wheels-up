import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
import 'package:wheels_up_v2/user/user_service.dart';

part 'user_provider.g.dart';

@riverpod
Future<void> updateUserProfile(Ref ref, UpdateUser updateUser) async {
  final userService = ref.read(userServiceProvider);
  try {
    await userService.updateCurrentUser(updateUser);
    
    // Update the auth notifier with the modified user
    // Invalidate the auth notifier
    ref.invalidate(authNotifierProvider);
    await ref.read(authNotifierProvider.future);
  } on ClientException catch (err) {
    final serverMsg = err.response["message"];
    throw Exception("Error updating user: $serverMsg");
  }
}

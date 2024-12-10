import 'package:pocketbase/pocketbase.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class UserService {
  late final PocketBase pb;
  late final AuthService2 authService;

  UserService({required this.pb, required this.authService});

  Future<User2> updateProfile(UpdateProfileRequest request) async {
    try {
      final record = await pb.collection('users').update(
            pb.authStore.record!.id,
            body: request.toJson(),
          );

      return User2.fromJson(record.toJson());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}

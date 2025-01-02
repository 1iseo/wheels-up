import 'dart:convert';
import 'dart:io';

import 'package:fake_http_client/fake_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/auth/auth_service.dart';
import 'package:wheels_up_v2/auth/persistence_manager.dart';
import 'package:wheels_up_v2/config/api_config.dart';

class _AuthSuccessHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(_) => FakeHttpClient((request, client) {
        final url = request.uri.toString();
        if (request.method == "POST") {
          if (url.contains("users/auth-with-password")) {
            return FakeHttpResponse(
              statusCode: 200,
              body: jsonEncode({
                "token": "JWT_TOKEN",
                "record": {
                  "collectionId": "pbc_2232277661",
                  "collectionName": "users",
                  "id": "test",
                  "username": "test",
                  "fullName": "test",
                  "email": "test@example.com",
                  "emailVisibility": true,
                  "verified": true,
                  "role": "pemilik",
                  "picture": "filename.jpg",
                  "createdAt": "2022-01-01 10:00:00.123Z",
                  "updatedAt": "2022-01-01 10:00:00.123Z"
                }
              }),
            );
          }
        }

        return FakeHttpResponse();
      });
}

void main() {
  setUp(() {
    HttpOverrides.global = _AuthSuccessHttpOverrides();
  });

  test('auth', () async {
    final pb = PocketBase(ApiConfig().pbApiUrl);
    final pm = InMemoryPersistenceManager();
    final authService =
        AuthService(pb, authPersistenceManager: pm);
    final user = await authService.login("test", "password");
    expect(user.id, "test");
    expect(await pm.get(), isNotNull);
    expect(pb.authStore.token.isEmpty, false);
 
    await authService.logout();
    expect(await pm.get(), isNull);
    expect(pb.authStore.token.isEmpty, true);
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/config/api_config.dart';
import 'package:wheels_up_v2/user/user_service.dart';
import 'package:fake_http_client/fake_http_client.dart';

class _UsersApiHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(_) => FakeHttpClient((request, client) {
        final url = request.uri.toString();
        if (request.method == "GET") {
          if (url.contains("users/records/test")) {
            return FakeHttpResponse(
              statusCode: 200,
              body: jsonEncode({
                "collectionId": "pbc_2232277661",
                "collectionName": "users",
                "id": "test",
                "username": "test username",
                "fullName": "test",
                "email": "test@example.com",
                "emailVisibility": true,
                "verified": true,
                "role": "pemilik",
                "picture": "filename.jpg",
                "createdAt": "2022-01-01 10:00:00.123Z",
                "updatedAt": "2022-01-01 10:00:00.123Z"
              }),
            );
          }

          if (url.contains("users/records/non_existent")) {
            return FakeHttpResponse(statusCode: 404, body: {
              {
                "code": 404,
                "message": "The requested resource wasn't found.",
                "data": {}
              }
            });
          }
        }
        return FakeHttpResponse();
      });
}

void main() {
  late PocketBase pb;
  late UserService userService;

  setUp(() {
    HttpOverrides.global = _UsersApiHttpOverrides();
    pb = PocketBase(ApiConfig().pbApiUrl);
    userService = UserService(pb);
  });

  test('parses user data correctly', () async {
    final result = await userService.getUserById("test");
    expect(result, isNotNull);
    expect(result?.id, "test");
    expect(result?.username, "test username");
    expect(result?.email, "test@example.com");
  });

  test('throws exception when user is not found', () async {
    expect(() => userService.getUserById("non_existent"), throwsA((e) {
      if (e is ClientException) {
        return true;
      }
      return false;
    }));
  });
}

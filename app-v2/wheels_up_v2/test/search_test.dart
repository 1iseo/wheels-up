import 'dart:developer';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:wheels_up_v2/auth/auth_service.dart';
import 'package:wheels_up_v2/auth/persistence_manager.dart';
import 'package:wheels_up_v2/common/service_providers.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWith((ref) => AuthService(
            ref.read(pocketBaseProvider),
            authPersistenceManager: InMemoryPersistenceManager()))
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('search', () async {
    await container.read(authServiceProvider).login('jdoe', '12345678');

    final response = await container
        .read(searchServiceProvider)
        .searchListings(query: 'bmw', page: 1);

    log("YA YA");
    // for (var listing in response) {
    //   log(listing.listing.name);
    // }
  });
}

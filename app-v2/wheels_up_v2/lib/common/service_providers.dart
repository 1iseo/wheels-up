import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/auth/auth_service.dart';
import 'package:wheels_up_v2/config/api_config.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';
import 'package:wheels_up_v2/rental/rental_service.dart';
import 'package:wheels_up_v2/search/search_service.dart';
import 'package:wheels_up_v2/user/user_service.dart';

part 'service_providers.g.dart';

@Riverpod(keepAlive: true)
PocketBase pocketBase(Ref ref) => PocketBase(ApiConfig().pbApiUrl);

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) => AuthService(ref.watch(pocketBaseProvider));

@Riverpod(keepAlive: true)
UserService userService(Ref ref) => UserService(ref.watch(pocketBaseProvider));

@Riverpod(keepAlive: true)
ListingService listingService(Ref ref) => ListingService(
    ref.watch(pocketBaseProvider), ref.watch(authServiceProvider));

@Riverpod(keepAlive: true)
SearchService searchService(Ref ref) => SearchService(
    MeiliSearchClient(ApiConfig().meiliSearchUrl, ApiConfig().meiliSearchKey),
    ref.watch(listingServiceProvider));

@Riverpod(keepAlive: true)
RentalRequestService rentalRequestService(Ref ref) => RentalRequestService(
    pb: ref.watch(pocketBaseProvider),
    authService: ref.watch(authServiceProvider));

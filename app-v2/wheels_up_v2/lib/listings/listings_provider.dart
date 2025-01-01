import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';
import 'package:wheels_up_v2/listings/listings_state.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
part 'listings_provider.g.dart';

@riverpod
class ListingsNotifier extends _$ListingsNotifier {
  @override
  Future<ListingsState> build() async {
    final listingsService = ref.read(listingServiceProvider);
    final response = await listingsService.getListingsWithPoster(page: 1);
    return ListingsState(listings: response);
  }

  // Future<void> loadMore() async {
  //   final currentState = state;
  //   if (currentState.isLoading || !currentState.hasValue) return;

  //   final currentListings = currentState.value!.listings;
  //   final nextPage = (currentListings?.page ?? 0) + 1;

  //   if (nextPage > (currentListings?.totalPages ?? 1)) return;

  //   final listingsService = ref.read(listingServiceProvider);
  //   final newResponse =
  //       await listingsService.getListingsWithPoster(page: nextPage);

  //   final updatedListings = ListingResponse(
  //     page: newResponse.page,
  //     perPage: newResponse.perPage,
  //     totalPages: newResponse.totalPages,
  //     totalItems: newResponse.totalItems,
  //     items: [...currentListings?.items ?? [], ...newResponse.items],
  //   );

  //   state = AsyncData(ListingsState(listings: updatedListings));
  // }

  Future<void> applyFilters(
      {double? minPrice, double? maxPrice, String? query}) async {
    final listingsService = ref.read(listingServiceProvider);
    final searchService = ref.read(searchServiceProvider);

    ListingResponse? response;
    if (query != null && query.isNotEmpty) {
      final searchHits = await searchService.searchListings(
        query: query,
        page: 1,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

      response = searchHits;
    } else {
      response = await listingsService.getFilteredListingsWithPoster(
        page: 1,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
    }

    state = AsyncData(ListingsState(listings: response));
  }

  Future<void> refreshListings(
      {double? minPrice, double? maxPrice, String? query}) async {
    return applyFilters(minPrice: minPrice, maxPrice: maxPrice, query: query);
  }

  Future<void> resetFilters() async {
    final listingsService = ref.read(listingServiceProvider);
    final response = await listingsService.getListingsWithPoster(page: 1);
    state = AsyncData(ListingsState(listings: response));
  }

  Future<void> loadMore(
      {double? minPrice, double? maxPrice, String? query}) async {
    final currentState = state;
    if (currentState.isLoading || !currentState.hasValue) return;

    final currentListings = currentState.value!.listings;
    final nextPage = (currentListings?.page ?? 0) + 1;

    if (nextPage > (currentListings?.totalPages ?? 1)) return;

    final listingsService = ref.read(listingServiceProvider);
    final searchService = ref.read(searchServiceProvider);

    ListingResponse? newResponse;
    if (query != null && query.isNotEmpty) {
      newResponse = await searchService.searchListings(
        query: query,
        page: 1,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
    } else {
      newResponse = await listingsService.getFilteredListingsWithPoster(
        page: nextPage,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
    }

    if (newResponse != null) {
      final updatedListings = ListingResponse(
        page: newResponse.page,
        perPage: newResponse.perPage,
        totalPages: newResponse.totalPages,
        totalItems: newResponse.totalItems,
        items: [...currentListings?.items ?? [], ...newResponse.items],
      );

      state = AsyncData(ListingsState(listings: updatedListings));
    } else {
      state = AsyncData(ListingsState(listings: null));
    }
  }
}

@riverpod
class CurrentUserListingsNotifier extends _$ListingsNotifier {
  @override
  Future<ListingsState> build() async {
    final listingsService = ref.read(listingServiceProvider);
    final authState = ref.read(authNotifierProvider);
    final currentUser = authState.requireValue.user!;

    final response = await listingsService.getListingsWithPosterFromPoster(
      currentUser.id,
    );

    return ListingsState(listings: response);
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState.isLoading || !currentState.hasValue) return;

    final currentListings = currentState.value!.listings;
    final nextPage = (currentListings?.page ?? 0) + 1;

    if (nextPage > (currentListings?.totalPages ?? 1)) return;

    final listingsService = ref.read(listingServiceProvider);
    final currentUser = ref.read(authNotifierProvider).requireValue.user!;
    final newResponse = await listingsService.getListingsWithPosterFromPoster(
      currentUser.id,
      page: nextPage,
    );

    final updatedListings = ListingResponse(
      page: newResponse.page,
      perPage: newResponse.perPage,
      totalPages: newResponse.totalPages,
      totalItems: newResponse.totalItems,
      items: [...currentListings?.items ?? [], ...newResponse.items],
    );

    state = AsyncData(ListingsState(listings: updatedListings));
  }
}

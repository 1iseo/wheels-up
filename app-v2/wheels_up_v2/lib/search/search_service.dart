import 'dart:developer';

import 'package:meilisearch/meilisearch.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';
import 'package:wheels_up_v2/search/search_model.dart';

class SearchService {
  final MeiliSearchClient client;
  final ListingService listingService;

  SearchService(this.client, this.listingService);

  Future<List<SearchHit>> _searchForHits({
    required String query,
    required int page,
    double? minPrice,
    double? maxPrice,
  }) async {
    final index = client.index('listings');

    // Build the filter string for price range
    List<String> filters = [];
    if (minPrice != null) {
      filters.add('pricePerHour >= $minPrice');
    }
    if (maxPrice != null) {
      filters.add('pricePerHour <= $maxPrice');
    }

    final filterString = filters.join(' AND ');

    final response = await index.search(
      query,
      SearchQuery(
        limit: 5,
        page: page,
        filter: filterString.isNotEmpty ? filterString : null,
      ),
    );

    return response.hits.map((hit) => SearchHit.fromJson(hit)).toList();
  }

  Future<ListingResponse?> searchListings({
    required String query,
    required int page,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final hits = await _searchForHits(
        query: query,
        page: page,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      final ids = hits.map((hit) => hit.id).toList();
      if (ids.isEmpty) return null;

      final listings = await listingService.getListingsWithPosterFromIds(ids);
      return listings;
    } catch (e, stackTrace) {
      log('Error searching listings', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

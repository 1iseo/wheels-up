import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/auth/auth_service.dart';
import 'package:wheels_up_v2/user/user_model.dart';

class Listing {
  final String id;
  final String name;
  final String description;
  final double pricePerHour;
  final String thumbnail;
  final List<String> requirements;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String posterId;

  Listing({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerHour,
    required this.thumbnail,
    required this.requirements,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.posterId,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'],
      name: json['title'],
      description: json['description'],
      pricePerHour: json['pricePerHour'].toDouble(),
      thumbnail: json['thumbnail'],
      requirements: List<String>.from(json['requirements']),
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      posterId: json['posterId'],
    );
  }
}

class ListingWithPoster {
  final Listing listing;
  final User poster;

  ListingWithPoster({
    required this.listing,
    required this.poster,
  });
}

class ListingResponse {
  final int page;
  final int perPage;
  final int totalPages;
  final int totalItems;
  final List<ListingWithPoster> items;

  ListingResponse({
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.totalItems,
    required this.items,
  });

  factory ListingResponse.fromJson(Map<String, dynamic> json) {
    return ListingResponse(
      page: json['page'],
      perPage: json['perPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
      items: (json['items'] as List)
          .map((item) => ListingWithPoster(
                listing: Listing.fromJson(item),
                poster: User.fromJson(item['expand']['posterId']),
              ))
          .toList(),
    );
  }
}

class CreateListingRequest {
  String title;
  String description;
  String location;
  int pricePerHour;
  List<String> requirements;
  List<int> thumbnail;
  String thumbnailFileName;
  String posterId;

  CreateListingRequest({
    required this.title,
    required this.description,
    required this.location,
    required this.pricePerHour,
    required this.requirements,
    required this.thumbnail,
    required this.thumbnailFileName,
    required this.posterId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'pricePerHour': pricePerHour,
      'requirements': json.encode(requirements),
      'posterId': posterId,
    };
  }
}

class UpdateListingRequest {
  String? title;
  String? description;
  String? location;
  int? pricePerHour;
  List<String>? requirements;
  List<int>? thumbnail;
  String? thumbnailFileName;

  UpdateListingRequest({
    this.title,
    this.description,
    this.location,
    this.pricePerHour,
    this.requirements,
    this.thumbnail,
    this.thumbnailFileName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (location != null) data['location'] = location;
    if (pricePerHour != null) data['pricePerHour'] = pricePerHour;
    if (requirements != null) data['requirements'] = json.encode(requirements);
    return data;
  }
}

class ListingService {
  final PocketBase pb;
  final AuthService authService;

  ListingService(this.pb, this.authService);

  Future<ListingResponse> getListings({int page = 1}) async {
    try {
      final response =
          await pb.collection('listings').getList(page: page, perPage: 5);
      return ListingResponse.fromJson(response.toJson());
    } catch (e, stackTrace) {
      log('Error fetching listings', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Listing> getListing(String id) async {
    try {
      final response = await pb.collection('listings').getOne(id);
      return Listing.fromJson(response.toJson());
    } catch (e, stackTrace) {
      log('Error fetching listing: $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Listing> createListing(CreateListingRequest request) async {
    try {
      final response = await pb
          .collection('listings')
          .create(body: request.toJson(), files: [
        http.MultipartFile.fromBytes(
          'thumbnail',
          request.thumbnail,
          filename: request.thumbnailFileName,
        )
      ]);
      return Listing.fromJson(response.toJson());
    } catch (e, stackTrace) {
      log('Error creating listing', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Listing> updateListing(
      String id, UpdateListingRequest request) async {
    try {
      final body = request.toJson();
      final files = List<http.MultipartFile>.empty(growable: true);
      // If thumbnail is not null, thumbnailName is also not null
      if (request.thumbnail != null) {
        files.add(
          http.MultipartFile.fromBytes(
            'thumbnail',
            request.thumbnail!,
            filename: request.thumbnailFileName,
          ),
        );
      }

      final response =
          await pb.collection('listings').update(id, body: body, files: files);

      return Listing.fromJson(response.toJson());
    } catch (e, stackTrace) {
      log('Error updating listing: $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      var listing = await pb.collection('listings').getOne(id);
      var posterId = listing.get('posterId');

      if ((await authService.loadLoggedInUser())?.id != posterId) {
        throw Exception('Not authorized to delete this listing');
      }
      await pb.collection('listings').delete(id);
    } catch (e, stackTrace) {
      log('Error deleting listing: $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<ListingWithPoster> getListingWithPoster(String id) async {
    try {
      final response = await pb.collection('listings').getOne(
            id,
            expand: 'posterId',
          );

      final listing = Listing.fromJson(response.toJson());
      final poster = User.fromJson(response.get('expand.posterId'));

      return ListingWithPoster(listing: listing, poster: poster);
    } catch (e, stackTrace) {
      log('Error fetching listing with poster: $id',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<ListingResponse> getListingsWithPoster({int page = 1}) async {
    try {
      final response = await pb.collection('listings').getList(
            page: page,
            perPage: 5,
            expand: 'posterId',
          );
      return ListingResponse.fromJson(response.toJson());
    } catch (e, stackTrace) {
      log('Error fetching listings with posters',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<ListingResponse> getListingsWithPosterFromPoster(String posterId,
      {int page = 1}) async {
    try {
      final response = await pb.collection('listings').getList(
            page: page,
            perPage: 5,
            expand: 'posterId',
            filter: 'posterId = "$posterId"',
          );
      return ListingResponse.fromJson(response.toJson());
    } catch (e, stackTrace) {
      log('Error fetching listings with posters from poster: $posterId',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<ListingResponse> getFilteredListingsWithPoster(
      {int page = 1, double? minPrice, double? maxPrice}) async {
    try {
      String filter = '';

      // Construct filter based on price range
      if (minPrice != null && maxPrice != null) {
        filter = 'pricePerHour >= $minPrice && pricePerHour <= $maxPrice';
      } else if (minPrice != null) {
        filter = 'pricePerHour >= $minPrice';
      } else if (maxPrice != null) {
        filter = 'pricePerHour <= $maxPrice';
      }

      final response = await pb
          .collection('listings')
          .getList(page: page, perPage: 5, filter: filter, expand: 'posterId', sort: '-createdAt');

      return ListingResponse.fromJson(response.toJson());
    } catch (e, stackTrace) {
      log('Error fetching filtered listings', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<ListingResponse> getListingsWithPosterFromIds(List<String> ids) async {
    // Turn the list of ids into a filter
    var filter = ids.map((id) => 'id="$id"').join(' || ');
    filter = '($filter)';

    try {
      final response = await pb.collection('listings').getList(
            page: 1,
            expand: 'posterId',
            perPage: ids.length,
            filter: filter,
          );
      return ListingResponse.fromJson(response.toJson());
    } catch (e, stackTrace) {
      log('Error fetching listings with posters from ids: $ids',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

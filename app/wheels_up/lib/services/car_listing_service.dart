import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up/services/pocketbase.dart';
import '../models/car_listing.dart';
import '../config/api_config.dart';
import 'auth_service.dart';

class CarListingService {
  final AuthService _authService = AuthService();
  late Dio _dio;

  CarListingService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> getListings({
    int? page,
    int? userId,
  }) async {
    try {
      final queryParams = {
        if (page != null) 'page': page,
        if (userId != null) 'posterId': userId,
      };

      final response = await _dio.get(
        '/listings',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final meta = response.data['meta'];
        return {
          'listings': data.map((json) => CarListing.fromJson(json)).toList(),
          'meta': meta,
        };
      }
      throw Exception('Failed to fetch listings');
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ?? 'Failed to fetch listings');
    }
  }

  Future<CarListing> createListing(Map<String, dynamic> listingData) async {
    try {
      final response = await _dio.post(
        '/listings',
        data: listingData,
      );

      if (response.statusCode == 200) {
        return CarListing.fromJson(response.data);
      }

      throw Exception('Failed to create listing');
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ?? 'Failed to create listing');
    }
  }

  Future<List<CarListing>> searchListings(String query) async {
    try {
      final response = await _dio.get(
        '/listings/search',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CarListing.fromJson(json)).toList();
      }

      throw Exception('Failed to search listings');
    } catch (e) {
      throw Exception('Failed to search listings: ${e.toString()}');
    }
  }

  Future<CarListing> updateListing(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '/listings/$id',
        data: data,
      );

      if (response.statusCode == 200) {
        return CarListing.fromJson(response.data);
      }
      throw Exception('Failed to update listing');
    } catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }
}

class ListingResponse {
  final int page;
  final int perPage;
  final int totalPages;
  final int totalItems;
  final List<CarListing2> items;

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
          .map((item) => CarListing2.fromJson(item))
          .toList(),
    );
  }
}

class CreateCarListingRequest {
  String title;
  String description;
  String location;
  int pricePerHour;
  List<String> requirements;
  String posterId;

  CreateCarListingRequest({
    required this.title,
    required this.description,
    required this.location,
    required this.pricePerHour,
    required this.requirements,
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

class CarListingService2 {
  final PocketBase pb = PocketbaseSingleton().pocketbase;

  Future<ListingResponse> getListings({int page = 1}) async {
    try {
      final response =
          await pb.collection('listings').getList(page: page, perPage: 5);
      return ListingResponse.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to fetch listings: $e');
    }
  }

  Future<CarListing2> getListing(String id) async {
    try {
      final response = await pb.collection('listings').getOne(id);
      return CarListing2.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to fetch listing: $e');
    }
  }

  Future<CarListing2> createListing(CreateCarListingRequest request) async {
    try {
      final response = await pb.collection('listings').create(
            body: request.toJson(),
          );
      return CarListing2.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to create listing: ${e.toString()}');
    }
  }

  Future<CarListing2> updateListing(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await pb.collection('listings').update(
            id,
            body: data,
          );
      return CarListing2.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to update listing: ${e.toString()}');
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      var listing = await pb.collection('listings').getOne(id);
      var posterId = listing.get('posterId');

      if (AuthService2().getCurrentUser()?.id != posterId) {
        throw Exception('Not authorized to delete this listing');
      }
      await pb.collection('listings').delete(id);
    } catch (e) {
      throw Exception('Failed to delete listing: ${e.toString()}');
    }
  }
}

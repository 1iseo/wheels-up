import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:pocketbase/pocketbase.dart';
import '../models/car_listing.dart';
import 'auth_service.dart';

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
  List<int> thumbnail;
  String thumbnailFileName;
  String posterId;

  CreateCarListingRequest({
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

class UpdateCarListingRequest {
  String? title;
  String? description;
  String? location;
  int? pricePerHour;
  List<String>? requirements;
  List<int>? thumbnail;
  String? thumbnailFileName;

  UpdateCarListingRequest({
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

class CarListingService {
  final PocketBase pb;
  final AuthService2 authService;

  CarListingService({required this.pb, required this.authService});

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
      final response = await pb
          .collection('listings')
          .create(body: request.toJson(), files: [
        http.MultipartFile.fromBytes(
          'thumbnail',
          request.thumbnail,
          filename: request.thumbnailFileName,
        )
      ]);
      return CarListing2.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to create listing: ${e.toString()}');
    }
  }

  Future<CarListing2> updateListing(
      String id, UpdateCarListingRequest request) async {
    try {
      final body = request.toJson();
      // If thumbnail is not null, thumbnailName is also not null
      final files = request.thumbnail != null
          ? [
              http.MultipartFile.fromBytes(
                'thumbnail',
                request.thumbnail!,
                filename: request.thumbnailFileName,
              )
            ]
          : [] as List<http.MultipartFile>;

      final response = await pb.collection('listings').update(
            id,
            body: body,
            files: files,
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

      if ((await authService.getCurrentUser())?.id != posterId) {
        throw Exception('Not authorized to delete this listing');
      }
      await pb.collection('listings').delete(id);
    } catch (e) {
      throw Exception('Failed to delete listing: ${e.toString()}');
    }
  }
}

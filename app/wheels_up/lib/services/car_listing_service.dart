import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up/services/pocketbase.dart';
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
      // thumbnail is skipped because it's handled separately
    };
  }
}

class CarListingService {
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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/models/user.dart';
import 'package:wheels_up/services/auth_service.dart';

class RentalRequestResponse {
  final int page;
  final int perPage;
  final int totalPages;
  final int totalItems;
  final List<RentalRequestWithRelations> items;

  RentalRequestResponse({
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.totalItems,
    required this.items,
  });

  factory RentalRequestResponse.fromJson(Map<String, dynamic> json) {
    return RentalRequestResponse(
      page: json['page'],
      perPage: json['perPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
      items: (json['items'] as List)
          .map((item) => RentalRequestWithRelations(
                rentalRequest: RentalRequest.fromJson(item),
                user: User2.fromJson(item['expand']['user']),
                listing: CarListing2.fromJson(item['expand']['listing']),
              ))
          .toList(),
    );
  }
}

class CreateRentalRequestRequest {
  String userId;
  String listingId;
  String email;
  String noTelepon;
  String address;
  String reason;
  int age;

  CreateRentalRequestRequest({
    required this.userId,
    required this.listingId,
    required this.email,
    required this.noTelepon,
    required this.address,
    required this.reason,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': [userId],
      'listing': [listingId],
      'email': email,
      'no_telepon': noTelepon,
      'address': address,
      'reason': reason,
      'age': age,
    };
  }
}

class UpdateRentalRequestRequest {
  String? email;
  String? noTelepon;
  String? address;
  String? reason;
  int? age;

  UpdateRentalRequestRequest({
    this.email,
    this.noTelepon,
    this.address,
    this.reason,
    this.age,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (email != null) data['email'] = email;
    if (noTelepon != null) data['no_telepon'] = noTelepon;
    if (address != null) data['address'] = address;
    if (reason != null) data['reason'] = reason;
    if (age != null) data['age'] = age;
    return data;
  }
}

class RentalRequestService {
  final PocketBase pb;
  final AuthService2 authService;

  RentalRequestService({required this.pb, required this.authService});

  Future<RentalRequestResponse> getRentalRequests({int page = 1}) async {
    try {
      final response = await pb.collection('rental_requests').getList(
            page: page,
            perPage: 30,
            expand: 'user,listing',
          );
      return RentalRequestResponse.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to fetch rental requests: $e');
    }
  }

  Future<RentalRequestWithRelations> getRentalRequest(String id) async {
    try {
      final response = await pb.collection('rental_requests').getOne(
            id,
            expand: 'user,listing',
          );

      return RentalRequestWithRelations(
        rentalRequest: RentalRequest.fromJson(response.toJson()),
        user: User2.fromJson(response.get('expand.user')),
        listing: CarListing2.fromJson(response.get('expand.listing')),
      );
    } catch (e) {
      throw Exception('Failed to fetch rental request: $e');
    }
  }

  Future<RentalRequest> createRentalRequest(
      CreateRentalRequestRequest request) async {
    try {
      final response =
          await pb.collection('rental_requests').create(body: request.toJson());
      return RentalRequest.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to create rental request: ${e.toString()}');
    }
  }

  Future<RentalRequest> updateRentalRequest(
      String id, UpdateRentalRequestRequest request) async {
    try {
      final response = await pb
          .collection('rental_requests')
          .update(id, body: request.toJson());
      return RentalRequest.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to update rental request: ${e.toString()}');
    }
  }

  Future<void> deleteRentalRequest(String id) async {
    try {
      var rentalRequest = await pb.collection('rental_requests').getOne(id);
      var userId = (rentalRequest.get('user') as List).first;

      if ((await authService.getCurrentUser())?.id != userId) {
        throw Exception('Not authorized to delete this rental request');
      }
      await pb.collection('rental_requests').delete(id);
    } catch (e) {
      throw Exception('Failed to delete rental request: ${e.toString()}');
    }
  }

  Future<List<RentalRequestWithRelations>> getUserRentalRequests(
      String userId) async {
    try {
      final response = await pb.collection('rental_requests').getList(
            filter: 'user = "$userId"',
            expand: 'user,listing',
          );

      return (response.items as List)
          .map((item) => RentalRequestWithRelations(
                rentalRequest: RentalRequest.fromJson(item.toJson()),
                user: User2.fromJson(item.get('expand.user')),
                listing: CarListing2.fromJson(item.get('expand.listing')),
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user rental requests: $e');
    }
  }

  Future<List<RentalRequestWithRelations>> getListingRentalRequests(
      String listingId) async {
    try {
      final response = await pb.collection('rental_requests').getList(
            filter: 'listing = "$listingId"',
            expand: 'user,listing',
          );

      return (response.items as List)
          .map((item) => RentalRequestWithRelations(
                rentalRequest: RentalRequest.fromJson(item.toJson()),
                user: User2.fromJson(item.get('expand.user')),
                listing: CarListing2.fromJson(item.get('expand.listing')),
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch listing rental requests: $e');
    }
  }
}

class RentalRequest {
  String? id;
  List<String>? user;
  List<String>? listing;
  String? email;
  String? noTelepon;
  String? address;
  String? reason;
  int? age;
  String? created;
  String? updated;

  RentalRequest({
    this.id,
    this.user,
    this.listing,
    this.email,
    this.noTelepon,
    this.address,
    this.reason,
    this.age,
    this.created,
    this.updated,
  });

  factory RentalRequest.fromJson(Map<String, dynamic> json) {
    return RentalRequest(
      id: json['id'],
      user: json['user'] != null ? List<String>.from(json['user']) : null,
      listing:
          json['listing'] != null ? List<String>.from(json['listing']) : null,
      email: json['email'],
      noTelepon: json['no_telepon'],
      address: json['address'],
      reason: json['reason'],
      age: json['age'],
      created: json['created'],
      updated: json['updated'],
    );
  }
}

class RentalRequestWithRelations {
  final RentalRequest rentalRequest;
  final User2 user;
  final CarListing2 listing;

  RentalRequestWithRelations({
    required this.rentalRequest,
    required this.user,
    required this.listing,
  });
}

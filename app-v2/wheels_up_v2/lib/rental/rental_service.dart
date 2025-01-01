import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/auth/auth_service.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';
import 'package:wheels_up_v2/user/user_model.dart';

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
                user: User.fromJson(item['expand']['user']),
                listing: Listing.fromJson(item['expand']['listing']),
              ))
          .toList(),
    );
  }
}

class CreateRentalRequestRequest {
  String posterUserId;
  String renterUserId;
  String listingId;
  String email;
  String noTelepon;
  String address;
  String reason;
  int age;
  DateTime startDate;
  DateTime endDate;
  int totalHours;
  double totalPrice;

  CreateRentalRequestRequest({
    required this.posterUserId,
    required this.renterUserId,
    required this.listingId,
    required this.email,
    required this.noTelepon,
    required this.address,
    required this.reason,
    required this.age,
    required this.startDate,
    required this.endDate,
    required this.totalHours,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'userPoster': [posterUserId],
      'userRenter': [renterUserId],
      'listing': [listingId],
      'email': email,
      'noTelepon': noTelepon,
      'address': address,
      'reason': reason,
      'age': age,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalHours': totalHours,
      'totalPrice': totalPrice,
      'status': 'pending',
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
  final AuthService authService;

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
        user: User.fromJson(response.get('expand.user')),
        listing: Listing.fromJson(response.get('expand.listing')),
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

  Future<void> updateRentalRequestStatus(String id, String status) async {
    try {      
      await pb.collection('rental_requests').update(id, body: {
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update rental request: ${e.toString()}');
    }
  }

  Future<void> deleteRentalRequest(String id) async {
    try {
      var rentalRequest = await pb.collection('rental_requests').getOne(id);
      var userId = (rentalRequest.get('user') as List).first;

      if ((await authService.loadLoggedInUser())?.id != userId) {
        throw Exception('Not authorized to delete this rental request');
      }
      await pb.collection('rental_requests').delete(id);
    } catch (e) {
      throw Exception('Failed to delete rental request: ${e.toString()}');
    }
  }

  Future<List<RentalRequestWithRelations>> getUserRentalRequestsSent(
      String userId) async {
    // TODO: Actually implement pagination
    try {
      final response = await pb.collection('rental_requests').getFullList(
            filter: 'userRenter = "$userId"',
            expand: 'userRenter,listing',
          );

      return response
          .toList()
          .map((item) => RentalRequestWithRelations(
                rentalRequest: RentalRequest.fromJson(item.toJson()),
                user: User.fromJson(item.get('expand.userRenter')),
                listing: Listing.fromJson(item.get('expand.listing')),
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user rental requests: $e');
    }
  }

  Future<List<RentalRequestWithRelations>> getUserRentalRequestsReceived(
      String userId) async {
    try {
      final response = await pb.collection('rental_requests').getFullList(
            filter: 'userPoster = "$userId"',
            expand: 'userRenter,listing',
          );

      return response.toList()
          .map((item) => RentalRequestWithRelations(
                rentalRequest: RentalRequest.fromJson(item.toJson()),
                user: User.fromJson(item.get('expand.userRenter')),
                listing: Listing.fromJson(item.get('expand.listing')),
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
            expand: 'userRenter,listing',
          );

      return (response.items as List)
          .map((item) => RentalRequestWithRelations(
                rentalRequest: RentalRequest.fromJson(item.toJson()),
                user: User.fromJson(item.get('expand.userRenter')),
                listing: Listing.fromJson(item.get('expand.listing')),
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch listing rental requests: $e');
    }
  }
}

class RentalRequest {
  String? id;
  String? posterUserId;
  String? renterUserId;
  String? listing;
  String? email;
  String? noTelepon;
  String? address;
  String? reason;
  int? age;
  DateTime? startDate;
  DateTime? endDate;
  int? totalHours;
  double? totalPrice;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  RentalRequest({
    this.id,
    this.posterUserId,
    this.renterUserId,
    this.listing,
    this.email,
    this.noTelepon,
    this.address,
    this.reason,
    this.age,
    this.startDate,
    this.endDate,
    this.totalHours,
    this.totalPrice,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RentalRequest.fromJson(Map<String, dynamic> json) {
    return RentalRequest(
      id: json['id'],
      posterUserId: json['userPoster'],
      renterUserId: json['userRenter'],
      listing: json['listing'],
      email: json['email'],
      noTelepon: json['noTelepon'],
      address: json['address'],
      reason: json['reason'],
      age: json['age'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalHours: json['totalHours'],
      totalPrice: double.parse(json['totalPrice'].toString()),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class RentalRequestWithRelations {
  final RentalRequest rentalRequest;
  final User user;
  final Listing listing;

  RentalRequestWithRelations({
    required this.rentalRequest,
    required this.user,
    required this.listing,
  });
}

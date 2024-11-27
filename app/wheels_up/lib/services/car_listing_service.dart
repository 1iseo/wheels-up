import 'package:dio/dio.dart';
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
      throw Exception(e.response?.data?['message'] ?? 'Failed to fetch listings');
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
      throw Exception(e.response?.data?['message'] ?? 'Failed to create listing');
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
}

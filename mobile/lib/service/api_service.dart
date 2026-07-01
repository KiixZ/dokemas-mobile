import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';
import '../models/category.dart';
import '../models/facility.dart';
import '../models/review.dart';
import '../config/api_config.dart';

class ApiService {
  Future<List<Destination>> fetchDestinations() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.destinations));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> body;

        if (decodedData is Map<String, dynamic>) {
          body = decodedData['data'] ?? [];
        } else if (decodedData is List) {
          body = decodedData;
        } else {
          throw Exception('Format data tidak dikenali');
        }

        return body.map((dynamic item) => Destination.fromJson(item)).toList();
      } else {
        throw Exception(
          'Gagal mengambil data dari server (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server backend: $e');
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categories));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Gagal mengambil data kategori');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server backend: $e');
    }
  }

  Future<List<Facility>> fetchFacilities() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.facilities));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Facility.fromJson(item)).toList();
      } else {
        throw Exception('Gagal mengambil data fasilitas');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server backend: $e');
    }
  }

  Future<List<Review>> fetchMyReviews(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.myReviews),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> body;

        if (decodedData is Map<String, dynamic>) {
          body = decodedData['data'] ?? [];
        } else if (decodedData is List) {
          body = decodedData;
        } else {
          throw Exception('Format data tidak dikenali');
        }

        return body.map((dynamic item) => Review.fromJson(item)).toList();
      } else {
        throw Exception(
          'Gagal mengambil data ulasan (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server backend: $e');
    }
  }

  Future<List<Review>> fetchDestinationReviews(int destinationId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.destinations}/$destinationId/reviews'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> body;

        if (decodedData is Map<String, dynamic>) {
          body = decodedData['data'] ?? [];
        } else if (decodedData is List) {
          body = decodedData;
        } else {
          throw Exception('Format data tidak dikenali');
        }

        return body.map((dynamic item) => Review.fromJson(item)).toList();
      } else {
        throw Exception(
          'Gagal mengambil data ulasan (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server backend: $e');
    }
  }

  Future<Review> postReview({
    required String token,
    required int destinationId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.destinations}/$destinationId/reviews'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        
        dynamic reviewData;
        if (decodedData is Map<String, dynamic>) {
          reviewData = decodedData['data'] ?? decodedData['review'] ?? decodedData;
        } else {
          reviewData = decodedData;
        }

        return Review.fromJson(reviewData);
      } else {
        final decoded = jsonDecode(response.body);
        throw Exception(decoded['message'] ?? 'Gagal mengirim ulasan');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server backend: $e');
    }
  }
}
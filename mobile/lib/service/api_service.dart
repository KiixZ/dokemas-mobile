import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';
import '../models/category.dart';
import '../models/facility.dart';
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
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';
import '../config/api_config.dart';

class ApiService {
  Future<List<Destination>> fetchDestinations() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.destinations));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> body;

        // Validasi: Jika response berbentuk Map, ambil array di dalam key 'data'
        if (decodedData is Map<String, dynamic>) {
          body = decodedData['data'] ?? [];
        } else if (decodedData is List) {
          // Jika response langsung berbentuk List mentah
          body = decodedData;
        } else {
          throw Exception('Format data tidak dikenali');
        }

        return body.map((dynamic item) => Destination.fromJson(item)).toList();
      } else {
        throw Exception('Gagal mengambil data dari server (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server backend: $e');
    }
  }
}
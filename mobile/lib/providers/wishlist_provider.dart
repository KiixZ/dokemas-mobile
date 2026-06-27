import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/destination.dart';

class WishlistProvider with ChangeNotifier {
  List<Destination> _wishlist = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Destination> get wishlist => _wishlist;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Map<String, String> _authHeaders(String token) => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<void> fetchWishlist(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.wishlist),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _wishlist = data.map((item) {
          // data api backend berbentuk wishlist berelasi ke destination
          return Destination.fromJson(item['destination']);
        }).toList();
      } else {
        _errorMessage = 'Gagal memuat wishlist (${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke server.';
      debugPrint('Error fetchWishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleWishlist(String token, int destinationId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.wishlistToggle),
        headers: _authHeaders(token),
        body: jsonEncode({'destination_id': destinationId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool isWishlisted = data['wishlisted'] ?? false;
        
        // Memanggil fetch ulang untuk memastikan sinkronisasi state
        await fetchWishlist(token);
        return isWishlisted;
      } else {
        throw Exception('Gagal mengubah wishlist (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error toggleWishlist: $e');
      throw Exception('Terjadi kesalahan pada jaringan atau server.');
    }
  }

  bool isWishlisted(int destinationId) {
    return _wishlist.any((dest) => dest.id == destinationId);
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/review.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Map<String, String> _authHeaders(String token) => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<void> fetchReviews(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.reviews),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List<dynamic> listData = [];
        if (decoded is List) {
          listData = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          listData = decoded['data'] as List;
        }
        
        _reviews = listData.map((item) => Review.fromJson(item)).toList();
      } else {
        _errorMessage = 'Gagal memuat ulasan (${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke server.';
      debugPrint('Error fetchReviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

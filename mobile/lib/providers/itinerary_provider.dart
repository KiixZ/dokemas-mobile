import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/itinerary_model.dart';

class ItineraryProvider with ChangeNotifier {
  List<ItineraryModel> _itineraries = [];
  ItineraryModel? _selectedItinerary;
  bool _isLoading = false;
  String? _errorMessage;

  List<ItineraryModel> get itineraries => _itineraries;
  ItineraryModel? get selectedItinerary => _selectedItinerary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Header standar untuk request yang membutuhkan autentikasi.
  Map<String, String> _authHeaders(String token) => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  // ─── LIST ─────────────────────────────────────────────────────────────

  /// Mengambil semua itinerary milik user yang sedang login.
  /// Dipanggil saat `ItineraryListPage` dibuka.
  Future<void> fetchItineraries(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.itineraries),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _itineraries =
            data.map((item) => ItineraryModel.fromJson(item)).toList();
      } else {
        _errorMessage = 'Gagal memuat data itinerary (${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke server. Periksa koneksi internet.';
      debugPrint('Error fetchItineraries: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ─── DETAIL ───────────────────────────────────────────────────────────

  /// Mengambil detail satu itinerary beserta items-nya.
  /// Dipanggil saat `ItineraryDetailPage` dibuka.
  Future<void> fetchItineraryDetail(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.itineraries}/$id'),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200) {
        _selectedItinerary =
            ItineraryModel.fromJson(jsonDecode(response.body));
      } else {
        _errorMessage =
            'Gagal memuat detail itinerary (${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke server. Periksa koneksi internet.';
      debugPrint('Error fetchItineraryDetail: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ─── CREATE ───────────────────────────────────────────────────────────

  /// Membuat itinerary baru. Mengembalikan `null` jika sukses, atau pesan error.
  Future<String?> createItinerary(
    String token, {
    required String title,
    DateTime? startDate,
    DateTime? endDate,
    String? note,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
      };
      if (startDate != null) {
        body['start_date'] = startDate.toIso8601String().split('T').first;
      }
      if (endDate != null) {
        body['end_date'] = endDate.toIso8601String().split('T').first;
      }
      if (note != null && note.trim().isNotEmpty) {
        body['note'] = note.trim();
      }

      final response = await http.post(
        Uri.parse(ApiConfig.itineraries),
        headers: _authHeaders(token),
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // Refresh list setelah berhasil membuat
        await fetchItineraries(token);
        return null; // Sukses
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Gagal membuat itinerary.';
      }
    } catch (e) {
      debugPrint('Error createItinerary: $e');
      return 'Terjadi kesalahan koneksi.';
    }
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────

  /// Memperbarui itinerary. Mengembalikan `null` jika sukses, atau pesan error.
  Future<String?> updateItinerary(
    String token,
    int id, {
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    String? note,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (startDate != null) {
        body['start_date'] = startDate.toIso8601String().split('T').first;
      }
      if (endDate != null) {
        body['end_date'] = endDate.toIso8601String().split('T').first;
      }
      if (note != null) body['note'] = note;

      final response = await http.put(
        Uri.parse('${ApiConfig.itineraries}/$id'),
        headers: _authHeaders(token),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        await fetchItineraries(token);
        return null;
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Gagal memperbarui itinerary.';
      }
    } catch (e) {
      debugPrint('Error updateItinerary: $e');
      return 'Terjadi kesalahan koneksi.';
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────────

  /// Menghapus itinerary. Mengembalikan `null` jika sukses, atau pesan error.
  Future<String?> deleteItinerary(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.itineraries}/$id'),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200) {
        _itineraries.removeWhere((item) => item.id == id);
        notifyListeners();
        return null;
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Gagal menghapus itinerary.';
      }
    } catch (e) {
      debugPrint('Error deleteItinerary: $e');
      return 'Terjadi kesalahan koneksi.';
    }
  }

  // ─── REMOVE ITEM ─────────────────────────────────────────────────────

  /// Menghapus satu item kegiatan dari itinerary.
  /// Mengembalikan `null` jika sukses, atau pesan error.
  Future<String?> removeItem(
    String token,
    int itineraryId,
    int itemId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.itineraries}/$itineraryId/items/$itemId'),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200) {
        // Hapus item dari state lokal agar UI langsung update
        if (_selectedItinerary != null &&
            _selectedItinerary!.id == itineraryId) {
          final updatedItems = _selectedItinerary!.items
              .where((item) => item.id != itemId)
              .toList();
          _selectedItinerary = ItineraryModel(
            id: _selectedItinerary!.id,
            title: _selectedItinerary!.title,
            startDate: _selectedItinerary!.startDate,
            endDate: _selectedItinerary!.endDate,
            note: _selectedItinerary!.note,
            itemsCount: updatedItems.length,
            items: updatedItems,
          );
          notifyListeners();
        }
        return null;
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Gagal menghapus kegiatan.';
      }
    } catch (e) {
      debugPrint('Error removeItem: $e');
      return 'Terjadi kesalahan koneksi.';
    }
  }

  /// Membersihkan detail itinerary saat keluar dari halaman detail.
  void clearSelectedItinerary() {
    _selectedItinerary = null;
  }
}

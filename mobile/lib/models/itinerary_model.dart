import 'package:flutter/material.dart';

/// Model untuk satu Itinerary (rencana perjalanan).
class ItineraryModel {
  final int id;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? note;
  final int itemsCount;
  final List<ItineraryItemModel> items;

  const ItineraryModel({
    required this.id,
    required this.title,
    this.startDate,
    this.endDate,
    this.note,
    this.itemsCount = 0,
    this.items = const [],
  });

  /// Parsing dari response `GET /api/itineraries` (list — tanpa items)
  /// dan `GET /api/itineraries/{id}` (detail — dengan items).
  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    // Parse items jika ada (hanya dari endpoint detail)
    List<ItineraryItemModel> parsedItems = [];
    if (json['items'] != null && json['items'] is List) {
      parsedItems = (json['items'] as List)
          .map((item) => ItineraryItemModel.fromJson(item))
          .toList();
    }

    return ItineraryModel(
      id: json['id'],
      title: json['title'] ?? '',
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
      note: json['note'],
      itemsCount: json['items_count'] ?? parsedItems.length,
      items: parsedItems,
    );
  }

  /// Format rentang tanggal ke string yang mudah dibaca.
  /// Contoh: "21 Jun 2026", "21 - 22 Jun 2026", "21 Jun - 3 Jul 2026"
  String get dateRangeText {
    const List<String> bulanNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    if (startDate == null) return 'Belum ada tanggal';

    final DateTime start = startDate!;
    final DateTime end = endDate ?? start;

    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return '${start.day} ${bulanNames[start.month - 1]} ${start.year}';
    }

    if (start.month == end.month && start.year == end.year) {
      return '${start.day} - ${end.day} ${bulanNames[start.month - 1]} ${start.year}';
    }

    return '${start.day} ${bulanNames[start.month - 1]} - ${end.day} ${bulanNames[end.month - 1]} ${end.year}';
  }

  /// Jumlah hari dari start_date sampai end_date.
  int get totalDays {
    if (startDate == null) return 0;
    final DateTime end = endDate ?? startDate!;
    return end.difference(startDate!).inDays + 1;
  }
}

/// Model untuk satu item kegiatan di dalam Itinerary.
class ItineraryItemModel {
  final int id;
  final int itineraryId;
  final int? destinationId;
  final String destinationName;
  final String destinationCategory;
  final String destinationThumbnail;
  final String destinationAddress;
  final DateTime? visitDate;
  final String? visitTime;
  final int order;
  final String? note;

  const ItineraryItemModel({
    required this.id,
    required this.itineraryId,
    this.destinationId,
    this.destinationName = '',
    this.destinationCategory = '',
    this.destinationThumbnail = '',
    this.destinationAddress = '',
    this.visitDate,
    this.visitTime,
    this.order = 0,
    this.note,
  });

  /// Parsing dari response API yang sudah di-load dengan relasi destination.category
  factory ItineraryItemModel.fromJson(Map<String, dynamic> json) {
    // Parse destination data (relasi nested)
    String destName = '';
    String destCategory = '';
    String destThumbnail = '';
    String destAddress = '';
    int? destId;

    if (json['destination'] != null && json['destination'] is Map) {
      final dest = json['destination'] as Map<String, dynamic>;
      destName = dest['name'] ?? '';
      
      String rawThumb = (dest['thumbnail_url'] ?? dest['image_url'] ?? '').toString();
      if (rawThumb.isNotEmpty && !rawThumb.startsWith('http')) {
        destThumbnail = 'https://porto-backend-dokemas.rryxja.easypanel.host/storage/$rawThumb';
      } else {
        destThumbnail = rawThumb.replaceFirst('http://', 'https://');
      }
      
      destAddress = dest['address'] ?? '';
      destId = dest['id'];

      // Category bisa berupa Map (relasi) atau String
      if (dest['category'] != null) {
        if (dest['category'] is Map) {
          destCategory = dest['category']['name']?.toString() ?? '';
        } else {
          destCategory = dest['category'].toString();
        }
      }
    }

    // Parse visit_time — backend mengirim format "HH:mm" atau "HH:mm:ss"
    String? parsedTime;
    if (json['visit_time'] != null) {
      final timeParts = json['visit_time'].toString().split(':');
      if (timeParts.length >= 2) {
        parsedTime = '${timeParts[0]}:${timeParts[1]}';
      }
    }

    return ItineraryItemModel(
      id: json['id'],
      itineraryId: json['itinerary_id'] ?? 0,
      destinationId: destId ?? json['destination_id'],
      destinationName: destName,
      destinationCategory: destCategory,
      destinationThumbnail: destThumbnail,
      destinationAddress: destAddress,
      visitDate: json['visit_date'] != null
          ? DateTime.tryParse(json['visit_date'].toString())
          : null,
      visitTime: parsedTime,
      order: json['order'] ?? 0,
      note: json['note'],
    );
  }

  /// Mapping kategori destinasi ke IconData Flutter.
  IconData get categoryIcon {
    switch (destinationCategory.toLowerCase()) {
      case 'alam':
      case 'nature':
      case 'waterfall':
      case 'mountain':
      case 'wisata alam':
        return Icons.park_outlined;
      case 'kuliner':
      case 'culinary':
      case 'makan siang':
      case 'kuliner khas':
      case 'kuliner lokal':
        return Icons.restaurant_outlined;
      case 'kuliner malam':
        return Icons.nightlight_round_outlined;
      case 'sejarah':
      case 'history':
      case 'edukasi':
      case 'education':
        return Icons.museum_outlined;
      case 'keluarga':
      case 'family':
        return Icons.family_restroom_outlined;
      case 'religi':
      case 'religious':
        return Icons.mosque_outlined;
      case 'belanja':
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'ikon kota':
        return Icons.location_city_outlined;
      default:
        return Icons.place_outlined;
    }
  }
}

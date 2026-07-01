import 'facility.dart';

class DestinationImage {
  final int id;
  final String imageUrl;

  const DestinationImage({required this.id, required this.imageUrl});

  factory DestinationImage.fromJson(Map<String, dynamic> json) {
    String rawThumb = (json['image_url'] ?? '').toString();
    String parsedUrl = rawThumb;
    if (rawThumb.isNotEmpty && !rawThumb.startsWith('http')) {
      parsedUrl = 'https://porto-backend-dokemas.rryxja.easypanel.host/storage/$rawThumb';
    } else {
      parsedUrl = rawThumb.replaceFirst('http://', 'https://');
    }
    return DestinationImage(
      id: json['id'], 
      imageUrl: parsedUrl,
    );
  }
}

/// Model destinasi wisata (tersambung backend).
class Destination {
  final int? id;
  final String name;
  final String area;
  final int? categoryId;
  final String category;
  final double rating;
  final int reviews;
  final int price;
  final bool active;
  final String openHour;
  final String closeHour;
  final String description;
  final List<Facility> facilities;
  final List<DestinationImage> images;
  final String thumbnailUrl;
  final double? lat;
  final double? lng;

  const Destination({
    this.id,
    required this.name,
    required this.area,
    this.categoryId,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.price,
    this.active = true,
    this.openHour = '08:00',
    this.closeHour = '17:00',
    this.description = '',
    this.facilities = const [],
    this.images = const [],
    this.thumbnailUrl = '',
    this.lat,
    this.lng,
  });

  String get imageUrl => thumbnailUrl.isNotEmpty 
      ? thumbnailUrl 
      : 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=300';

  /// Fungsi untuk mapping data dari Database/API JSON yang aman
  factory Destination.fromJson(Map<String, dynamic> json) {
    // Helper untuk konversi category dari API backend ke bahasa Indonesia (agar cocok dengan UI)
    String mapCategory(String? apiCategory) {
      if (apiCategory == null) return 'Alam';
      switch (apiCategory.toLowerCase()) {
        case 'waterfall':
        case 'mountain':
        case 'nature':
        case 'alam':
          return 'Alam';
        case 'family':
        case 'keluarga':
          return 'Keluarga';
        case 'culinary':
        case 'kuliner':
          return 'Kuliner';
        case 'education':
        case 'edukasi':
        case 'sejarah':
        case 'history':
          return 'Edukasi';
        case 'religious':
        case 'religi':
          return 'Religi';
        default:
          return 'Alam'; 
      }
    }

    // Parsing data category secara dinamis baik berupa String maupun Map
    String? apiCategoryStr;
    if (json['category'] != null) {
      if (json['category'] is Map) {
        apiCategoryStr = json['category']['name']?.toString() ?? json['category']['slug']?.toString();
      } else {
        apiCategoryStr = json['category'].toString();
      }
    } else {
      apiCategoryStr = json['category_id']?.toString();
    }

    String parseTime(String? timeStr) {
      if (timeStr == null || timeStr.isEmpty) return '00:00';
      final parts = timeStr.split(':');
      if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
      return '00:00';
    }

    String openHour = '08:00';
    String closeHour = '17:00';
    if (json['opening_hours'] != null) {
      final times = json['opening_hours'].toString().split('-');
      if (times.isNotEmpty) openHour = parseTime(times[0].trim());
      if (times.length > 1) closeHour = parseTime(times[1].trim());
    }

    return Destination(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'] ?? '',
      area: json['address'] ?? '',
      category: mapCategory(apiCategoryStr),
      rating: (json['rating_avg'] ?? 0).toDouble(),
      reviews: json['rating_count'] ?? 0,
      price: (json['price'] ?? 0).toInt(),
      active: json['is_popular'] == 1 || json['is_popular'] == true,
      openHour: openHour,
      closeHour: closeHour,
      description: json['description'] ?? '',
      lat: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      lng: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      thumbnailUrl: () {
        String rawThumb = (json['thumbnail_url'] ?? '').toString();
        if (rawThumb.isNotEmpty && !rawThumb.startsWith('http')) {
          return 'https://porto-backend-dokemas.rryxja.easypanel.host/storage/$rawThumb';
        }
        return rawThumb.replaceFirst('http://', 'https://');
      }(),
      facilities: json['facilities'] != null
          ? (json['facilities'] as List)
                .map((e) => Facility.fromJson(e))
                .toList()
          : [],
      images: json['images'] != null
          ? (json['images'] as List)
                .map((e) => DestinationImage.fromJson(e))
                .toList()
          : [],
    );
  }
}

/// Format harga -> "Rp 15.000".
String formatRupiah(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

/// Kategori dipakai di filter chip & dropdown form.
const destinationCategories = [
  'Alam',
  'Keluarga',
  'Kuliner',
  'Edukasi',
  'Religi',
];

/// Master fasilitas buat multi-select di form
const facilityOptions = [
  'Toilet',
  'Parkir',
  'Mushola',
  'Warung',
  'Gazebo',
  'Spot Foto',
  'Wahana Air',
  'Penginapan',
  'Wifi',
];
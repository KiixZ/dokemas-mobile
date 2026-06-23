/// Model destinasi wisata
class Destination {
  final String name;
  final String area; 
  final String category; // Disamakan dengan UI: "Alam", "Keluarga", "Kuliner", "Edukasi", "Religi"
  final double rating; 
  final String reviews; 
  final int price; 
  final bool active;
  final String openHour; 
  final String closeHour; 
  final List<String> facilities; 
  final double? lat; 
  final double? lng; 
  final String imageUrl;

  const Destination({
    required this.name,
    required this.area,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.price,
    this.active = true,
    this.openHour = '08:00',
    this.closeHour = '17:00',
    this.facilities = const [],
    this.lat,
    this.lng,
    this.imageUrl = 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=300', 
  });

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

    // Parsing list fasilitas secara aman
    List<String> parsedFacilities = [];
    if (json['facilities'] != null && json['facilities'] is List) {
      parsedFacilities = (json['facilities'] as List).map((f) => f.toString()).toList();
    }

    return Destination(
      name: json['name']?.toString() ?? '',
      area: json['address']?.toString() ?? json['description']?.toString() ?? 'Banyumas',
      category: mapCategory(apiCategoryStr),
      rating: json['rating_avg'] != null
          ? (double.tryParse(json['rating_avg'].toString()) ?? 0.0)
          : (json['rating'] != null ? (double.tryParse(json['rating'].toString()) ?? 0.0) : 0.0),
      reviews: json['rating_count']?.toString() ?? json['reviews']?.toString() ?? '0',
      price: json['price'] != null ? (int.tryParse(json['price'].toString()) ?? 0) : 0,
      active: json['active'] is bool ? json['active'] : true,
      openHour: json['opening_hours']?.toString() ?? json['open_hour']?.toString() ?? '08:00',
      closeHour: json['closing_hours']?.toString() ?? json['close_hour']?.toString() ?? '17:00',
      facilities: parsedFacilities,
      lat: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      lng: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      imageUrl: json['thumbnail_url'] ??
          json['thumbnail'] ??
          json['image_url'] ??
          'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=300',
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

/// Data dummy yang disesuaikan kategorinya dengan UI HomePage
const dummyDestinations = [
  Destination(
    name: 'Curug Bayan Baturraden',
    area: 'Baturraden, Banyumas',
    category: 'Alam',
    rating: 4.8,
    reviews: '1.2k',
    price: 15000,
    active: true,
    openHour: '07:00',
    closeHour: '17:00',
    facilities: ['Toilet', 'Parkir', 'Warung'],
  ),
  Destination(
    name: 'Bukit Tranggulasih',
    area: 'Sumbang, Banyumas',
    category: 'Alam',
    rating: 4.5,
    reviews: '842',
    price: 10000,
    active: false,
    openHour: '24 Jam',
    closeHour: '-',
    facilities: ['Parkir', 'Spot Foto', 'Mushola'],
  ),
  Destination(
    name: 'Soto Sokaraja Asli',
    area: 'Sokaraja, Banyumas',
    category: 'Kuliner',
    rating: 4.9,
    reviews: '2.5k',
    price: 25000,
    active: true,
    openHour: '09:00',
    closeHour: '21:00',
    facilities: ['Toilet', 'Wifi', 'Parkir'],
  ),
];

/// Kategori yang sinkron dengan UI utama
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
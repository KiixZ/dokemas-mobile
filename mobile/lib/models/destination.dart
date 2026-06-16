/// Model destinasi wisata (UI only, belum konek backend).
class Destination {
  final String name;
  final String area; // mis. "Baturraden, Banyumas"
  final String category; // mis. "Waterfall"
  final double rating; // 0..5
  final String reviews; // mis. "1.2k"
  final int price; // rupiah, mis. 15000
  final bool active;
  final String openHour; // jam buka "08:00"
  final String closeHour; // jam tutup "17:00"
  final List<String> facilities; // mis. ["Toilet", "Parkir"]
  final double? lat; // latitude
  final double? lng; // longitude

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
  });
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

/// Data dummy buat halaman kelola destinasi.
const dummyDestinations = [
  Destination(
    name: 'Curug Bayan Baturraden',
    area: 'Baturraden, Banyumas',
    category: 'Waterfall',
    rating: 4.8,
    reviews: '1.2k',
    price: 15000,
    active: true,
  ),
  Destination(
    name: 'Bukit Tranggulasih',
    area: 'Sumbang, Banyumas',
    category: 'Mountain',
    rating: 4.5,
    reviews: '842',
    price: 10000,
    active: false,
  ),
  Destination(
    name: 'Soto Sokaraja Asli',
    area: 'Sokaraja, Banyumas',
    category: 'Culinary',
    rating: 4.9,
    reviews: '2.5k',
    price: 25000,
    active: true,
  ),
];

/// Kategori dipakai di filter chip & dropdown form.
const destinationCategories = [
  'Waterfall',
  'Mountain',
  'Culinary',
  'Beach',
  'Culture',
];

/// Master fasilitas buat multi-select di form.
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

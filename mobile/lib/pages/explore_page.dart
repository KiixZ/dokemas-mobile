import 'package:flutter/material.dart';
import 'package:mobile/components/filter_bottom_sheet.dart';
import 'package:mobile/pages/detail_destinasi_screen.dart';
import '../theme/app_colors.dart';

class ExplorePage extends StatefulWidget {
  final String? searchQuery; // Menerima lemparan teks dari beranda

  const ExplorePage({super.key, this.searchQuery});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late TextEditingController _searchController;
  String _currentQuery = '';
  
  // 1. Tambahkan state untuk melacak kategori yang dipilih (Default: 'Semua')
  String _selectedCategory = 'Semua';

  // Daftar tags/kategori tetap yang digunakan di aplikasi
  final List<String> _tags = ['Semua', 'Terpopuler', 'Dekat Kamu', 'Murah Meriah', 'Alam'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery ?? '');
    _currentQuery = widget.searchQuery ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            // 1. Header Halaman Explore
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Eksplor Destinasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 2. Search Bar & Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSearchBar(context),
            ),
            const SizedBox(height: 15),

            // 3. Tab Kategori Kecil / Tags Cepat (Sekarang Interaktif)
            _buildQuickTags(),
            const SizedBox(height: 10),

            // 4. Grid Hasil Destinasi (Otomatis ter-filter)
            Expanded(child: _buildDestinationGrid()),
          ],
        ),
      ),
    );
  }

  // SEARCH BAR
  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      } else {
                        setState(() {
                          _currentQuery = value;
                        });
                      }
                    },
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Cari tempat wisata terdekat...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Tombol Filter Bottom Sheet
        InkWell(
          onTap: () {
            showFilterBottomSheet(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // QUICK TAGS / FILTER KATEGORI SINGKAT (BERFUNGSI)
  Widget _buildQuickTags() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _tags.length,
        itemBuilder: (context, index) {
          final tag = _tags[index];
          // Validasi status aktif dicocokkan dengan nilai variabel state _selectedCategory
          final isSelected = _selectedCategory == tag; 
          
          return GestureDetector(
            onTap: () {
              // Ubah state kategori saat salah satu tag diklik
              setState(() {
                _selectedCategory = tag;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // GRID DESTINASI GABUNGAN LOGIKA FILTER CARI & TABS KATEGORI
  Widget _buildDestinationGrid() {
    // Menambahkan field 'tags' dummy pada data mentah agar bisa difilter oleh Quick Tags
    final exploreItems = [
      {
        'name': 'Lokawisata Baturraden',
        'location': 'Baturraden',
        'fullLocation': 'Baturraden, Banyumas',
        'price': 'Rp 25.000',
        'rating': '4.8',
        'reviewCount': '1.2k ulasan',
        'distance': '15 mnt',
        'openingHours': '08:00 -\n17:00',
        'description': 'Nikmati udara segar pegunungan dan panorama alam yang memukau di Baturraden...',
        'image': 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=300',
        'tags': ['Terpopuler', 'Dekat Kamu', 'Alam'],
      },
      {
        'name': 'Menara Pandang',
        'location': 'Purwokerto Timur',
        'fullLocation': 'Purwokerto Timur, Banyumas',
        'price': 'Rp 15.000',
        'rating': '4.9',
        'reviewCount': '856 ulasan',
        'distance': '5 km',
        'openingHours': '09:00 -\n21:00',
        'description': 'Menara Pandang Purwokerto merupakan landmark ikonik...',
        'image': 'https://images.unsplash.com/photo-1596422846543-75c6fc18a523?w=300',
        'tags': ['Terpopuler', 'Murah Meriah'],
      },
      {
        'name': 'Taman Balai Kemambang',
        'location': 'Purwokerto Utara',
        'fullLocation': 'Purwokerto Utara, Banyumas',
        'price': 'Rp 10.000',
        'rating': '4.6',
        'reviewCount': '632 ulasan',
        'distance': '3 km',
        'openingHours': '06:00 -\n18:00',
        'description': 'Taman Balai Kemambang adalah taman kota yang asri...',
        'image': 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=300',
        'tags': ['Dekat Kamu', 'Murah Meriah'],
      },
      {
        'name': 'Hutan Pinus Limpakuwus',
        'location': 'Sumbang',
        'fullLocation': 'Sumbang, Banyumas',
        'price': 'Rp 20.000',
        'rating': '4.7',
        'reviewCount': '478 ulasan',
        'distance': '20 km',
        'openingHours': '07:00 -\n17:00',
        'description': 'Hutan Pinus Limpakuwus menawarkan suasana sejuk...',
        'image': 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=300',
        'tags': ['Terpopuler', 'Alam'],
      },
      {
        'name': 'Curug Jenggala',
        'location': 'Baturraden',
        'fullLocation': 'Baturraden, Banyumas',
        'price': 'Rp 10.000',
        'rating': '4.8',
        'reviewCount': '920 ulasan',
        'distance': '18 km',
        'openingHours': '07:00 -\n16:00',
        'description': 'Curug Jenggala adalah air terjun tersembunyi...',
        'image': 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=300',
        'tags': ['Murah Meriah', 'Alam'],
      },
      {
        'name': 'The Village Purwokerto',
        'location': 'Baturraden',
        'fullLocation': 'Baturraden, Banyumas',
        'price': 'Rp 25.000',
        'rating': '4.5',
        'reviewCount': '345 ulasan',
        'distance': '14 km',
        'openingHours': '09:00 -\n20:00',
        'description': 'The Village Purwokerto adalah destinasi wisata modern...',
        'image': 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=300',
        'tags': ['Dekat Kamu'],
      },
    ];

    // Proses Penyaringan Berantai (Query Search & Tag Kategori)
    final filteredItems = exploreItems.where((item) {
      final name = item['name'].toString().toLowerCase();
      final location = item['location'].toString().toLowerCase();
      final query = _currentQuery.toLowerCase();
      final tagsList = item['tags'] as List<String>;

      // Aturan 1: Validasi kecocokan Search Bar
      bool matchesSearch = name.contains(query) || location.contains(query);

      // Aturan 2: Validasi kecocokan Kategori Tab Atas
      bool matchesCategory = _selectedCategory == 'Semua' || tagsList.contains(_selectedCategory);

      // Item lolos jika memenuhi kedua kriteria
      return matchesSearch && matchesCategory;
    }).toList();

    // Tampilkan pesan kosong jika tidak ada wisata yang lolos filter
    if (filteredItems.isEmpty) {
      return const Center(
        child: Text(
          'Wisata tidak ditemukan.',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailDestinasiScreen(
                  title: item['name'] as String,
                  imageUrl: item['image'] as String,
                  rating: item['rating'] as String,
                  reviewCount: item['reviewCount'] as String,
                  location: item['fullLocation'] as String,
                  price: item['price'] as String,
                  distance: item['distance'] as String,
                  openingHours: item['openingHours'] as String,
                  description: item['description'] as String,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          item['image'] as String,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey.shade200),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                item['rating'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              item['location'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['price'] as String,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
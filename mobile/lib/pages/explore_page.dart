import 'package:flutter/material.dart';
import 'package:mobile/components/filter_bottom_sheet.dart';
import '../theme/app_colors.dart';

class ExplorePage extends StatefulWidget {
  final String? searchQuery; // Menerima lemparan teks dari beranda

  const ExplorePage({super.key, this.searchQuery});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan teks pencarian dari Beranda jika ada
    _searchController = TextEditingController(text: widget.searchQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Tetap konsisten dengan Beranda
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

            // 2. Search Bar & Filter (Sesuai dengan desain Beranda tanpa kotak ganda)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSearchBar(context),
            ),
            const SizedBox(height: 15),

            // 3. Tab Kategori Kecil/Tags Cepat
            _buildQuickTags(),
            const SizedBox(height: 10),

            // 4. Grid Hasil Destinasi
            Expanded(
              child: _buildDestinationGrid(),
            ),
          ],
        ),
      ),
    );
  }

  // SEARCH BAR CLEAN DAN PROFESIONAL (SAMA DENGAN BERANDA)
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
                    controller: _searchController, // Hubungkan ke controller
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Cari tempat wisata terdekat...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent, // Menghilangkan kotak dalam pengganggu
                      contentPadding: EdgeInsets.symmetric(vertical: 12), // Teks pas di tengah
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Tombol Filter
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

  // QUICK TAGS / FILTER KATEGORI SINGKAT
  Widget _buildQuickTags() {
    final tags = ['Semua', 'Terpopuler', 'Dekat Kamu', 'Murah Meriah', 'Alam'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0; // 'Semua' aktif secara default
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: Center(
              child: Text(
                tags[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // GRID DESTINASI (MEMPERBAIKI ERROR ITEMBUILDER)
  Widget _buildDestinationGrid() {
    final exploreItems = [
      {
        'name': 'Lokawisata Baturraden',
        'location': 'Baturraden',
        'price': 'Rp 25.000',
        'rating': '4.8',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'name': 'Menara Pandang',
        'location': 'Purwokerto Timur',
        'price': 'Rp 15.000',
        'rating': '4.9',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'name': 'Taman Balai Kemambang',
        'location': 'Purwokerto Utara',
        'price': 'Rp 10.000',
        'rating': '4.6',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'name': 'Hutan Pinus Limpakuwus',
        'location': 'Sumbang',
        'price': 'Rp 20.000',
        'rating': '4.7',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'name': 'Curug Jenggala',
        'location': 'Baturraden',
        'price': 'Rp 10.000',
        'rating': '4.8',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'name': 'The Village Purwokerto',
        'location': 'Baturraden',
        'price': 'Rp 25.000',
        'rating': '4.5',
        'image': 'https://via.placeholder.com/150'
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: exploreItems.length,
      itemBuilder: (context, index) {
        final item = exploreItems[index];
        return Container(
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
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        image: DecorationImage(
                          image: NetworkImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              item['rating']!,
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
                      item['name']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            item['location']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['price']!,
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
        );
      },
    );
  }
}
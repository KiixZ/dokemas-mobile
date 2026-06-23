import 'package:flutter/material.dart';
import 'package:mobile/components/filter_bottom_sheet.dart';
import 'package:mobile/pages/detail_destinasi_screen.dart';
import '../theme/app_colors.dart';
import '../models/destination.dart'; // Import model destinasi timmu
import '../service/api_service.dart'; // Import service API

class ExplorePage extends StatefulWidget {
  final String? searchQuery;

  const ExplorePage({super.key, this.searchQuery});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late TextEditingController _searchController;
  String _currentQuery = '';
  
  // Default filter kategori diganti 'Semua'
  String _selectedCategory = 'Semua';

  // Variabel penampung request data async
  late Future<List<dynamic>> _futureExploreData;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery ?? '');
    _currentQuery = widget.searchQuery ?? '';
    // Fetch data dari database lewat API secara paralel
    _futureExploreData = Future.wait([
      ApiService().fetchDestinations(),
      ApiService().fetchCategories(),
    ]);
  }

  // Helper untuk memetakan nama kategori DB ke standar UI Indonesia
  List<String> _mapCategoryNames(List<Map<String, dynamic>> rawCategories) {
    if (rawCategories.isEmpty) {
      return destinationCategories;
    }

    String mapName(String name) {
      switch (name.toLowerCase()) {
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
          return name;
      }
    }

    final Set<String> seenNames = {};
    for (var cat in rawCategories) {
      final name = cat['name']?.toString() ?? '';
      if (name.isNotEmpty) {
        seenNames.add(mapName(name));
      }
    }

    return seenNames.toList();
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
        child: FutureBuilder<List<dynamic>>(
          future: _futureExploreData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Gagal memuat data: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final allItems = (snapshot.data?[0] as List<Destination>?) ?? [];
            final rawCategories = (snapshot.data?[1] as List<Map<String, dynamic>>?) ?? [];
            
            // Satukan tag 'Semua' dengan list kategori dinamis dari DB
            final List<String> tags = ['Semua', ..._mapCategoryNames(rawCategories)];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      if (Navigator.canPop(context)) ...[
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios, color: AppColors.primaryDark, size: 20),
                        ),
                        const SizedBox(width: 10),
                      ],
                      const Text(
                        'Eksplor Destinasi',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildSearchBar(context),
                ),
                const SizedBox(height: 15),

                // Kategori Chip Dinamis
                _buildQuickTags(tags),
                const SizedBox(height: 10),

                // Grid Hasil dari Database
                Expanded(child: _buildDestinationGrid(allItems)),
              ],
            );
          }
        ),
      ),
    );
  }

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
                      setState(() {
                        _currentQuery = value;
                      });
                    },
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Cari tempat wisata terdekat...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: _currentQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _currentQuery = '';
                                });
                              },
                              child: const Icon(Icons.clear, color: Colors.grey, size: 18),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () => showFilterBottomSheet(context),
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

  Widget _buildQuickTags(List<String> tags) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          final isSelected = _selectedCategory == tag;

          return GestureDetector(
            onTap: () {
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
                  color: isSelected ? Colors.transparent : Colors.grey.withValues(alpha: 0.2),
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

  Widget _buildDestinationGrid(List<Destination> allItems) {
    // Gabungan filter query pencarian & kategori dinamis
    final filteredItems = allItems.where((item) {
      final name = item.name.toLowerCase();
      final area = item.area.toLowerCase();
      final query = _currentQuery.toLowerCase();

      bool matchesSearch = name.contains(query) || area.contains(query);
      bool matchesCategory = _selectedCategory == 'Semua' || item.category.toLowerCase() == _selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

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
                      title: item.name,
                      imageUrl: item.imageUrl,
                      rating: item.rating.toString(),
                      reviewCount: '${item.reviews} ulasan',
                      location: item.area,
                      price: formatRupiah(item.price), 
                      distance: '-', // Bisa diganti logika jarak jika lat/lng dihitung
                      openingHours: '${item.openHour} -\n${item.closeHour}',
                      description: 'Kategori: ${item.category}. Fasilitas: ${item.facilities.map((f) => f.name).join(", ")}', 
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
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey.shade200, child: const Icon(Icons.broken_image, color: Colors.grey)),
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
                                    item.rating.toString(),
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
                            item.name,
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
                                  item.area,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatRupiah(item.price),
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
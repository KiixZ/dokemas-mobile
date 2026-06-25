import 'package:flutter/material.dart';
import 'package:mobile/components/filter_bottom_sheet.dart';
import 'package:mobile/pages/detail_destinasi_screen.dart';
import '../theme/app_colors.dart';
import '../models/destination.dart'; // Import model destinasi timmu
import '../service/api_service.dart'; // Import service API
import '../widgets/destination_card.dart';

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

  // Menggabungkan 'Semua' dengan list kategori yang ada di file model temanmu
  final List<String> _tags = ['Semua', ...destinationCategories];

  // Variabel penampung request data async
  late Future<List<Destination>> _futureDestinations;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery ?? '');
    _currentQuery = widget.searchQuery ?? '';
    // Fetch data dari database lewat API sekali saja saat page di-load
    _futureDestinations = ApiService().fetchDestinations();
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  if (Navigator.canPop(context)) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.primaryDark,
                        size: 20,
                      ),
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
            _buildQuickTags(),
            const SizedBox(height: 10),

            // Grid Hasil dari Database
            Expanded(child: _buildDestinationGrid()),
          ],
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
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
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
                              child: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                                size: 18,
                              ),
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

  Widget _buildQuickTags() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _tags.length,
        itemBuilder: (context, index) {
          final tag = _tags[index];
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
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
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

  Widget _buildDestinationGrid() {
    return FutureBuilder<List<Destination>>(
      future: _futureDestinations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
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

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Tidak ada destinasi dari database.'),
          );
        }

        final allItems = snapshot.data!;

        // Gabungan filter query pencarian & kategori dinamis
        final filteredItems = allItems.where((item) {
          final name = item.name.toLowerCase();
          final area = item.area.toLowerCase();
          final query = _currentQuery.toLowerCase();

          bool matchesSearch = name.contains(query) || area.contains(query);
          bool matchesCategory =
              _selectedCategory == 'Semua' ||
              item.category == _selectedCategory;

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
            return DestinationCard(
              destination: item,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailDestinasiScreen(
                      destinationId: item.id ?? 0,
                      title: item.name,
                      imageUrl: item.imageUrl,
                      rating: item.rating.toString(),
                      reviewCount: '${item.reviews} ulasan',
                      location: item.area,
                      price: formatRupiah(item.price),
                      distance:
                          '-', // Bisa diganti logika jarak jika lat/lng dihitung
                      openingHours: '${item.openHour} -\n${item.closeHour}',
                      description:
                          'Kategori: ${item.category}. Fasilitas: ${item.facilities.map((f) => f.name).join(", ")}',
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

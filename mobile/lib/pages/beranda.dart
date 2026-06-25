import 'package:flutter/material.dart';
import '../components/global_header.dart';
import 'package:mobile/components/filter_bottom_sheet.dart';
import 'package:mobile/pages/detail_destinasi_screen.dart';
import '../theme/app_colors.dart';
import 'notification_page.dart';
import 'package:mobile/pages/explore_page.dart';
import '../models/destination.dart';
import '../service/api_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/api_config.dart';

// Fungsi helper untuk memformat angka menjadi Rupiah dinamis
String formatRupiah(int price) {
  return 'Rp ${price.toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}';
}

class HomePage extends StatefulWidget {
  final void Function(int)? onTabChanged;
  const HomePage({super.key, this.onTabChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Alam';

  late Future<List<Destination>> _futureDestinations;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Alam', 'icon': Icons.terrain},
    {'name': 'Keluarga', 'icon': Icons.people},
    {'name': 'Kuliner', 'icon': Icons.restaurant},
    {'name': 'Edukasi', 'icon': Icons.school},
    {'name': 'Religi', 'icon': Icons.church},
  ];

  @override
  void initState() {
    super.initState();
    _futureDestinations = ApiService().fetchDestinations();
  }

  ImageProvider _resolveAvatarImage(String? avatar) {
    if (avatar != null && avatar.isNotEmpty) {
      if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
        return NetworkImage(avatar);
      }
      final domain = ApiConfig.baseUrl.replaceAll('/api', '');
      final fullUrl = avatar.startsWith('/')
          ? '$domain$avatar'
          : '$domain/$avatar';
      return NetworkImage(fullUrl);
    }
    return const NetworkImage(
      'https://via.placeholder.com/150/grey/white?text=?',
    );
  }

  void _showAllCategoriesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Semua Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final item = _categories[index];
                final isActive = _selectedCategory == item['name'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = item['name'] as String;
                    });
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isActive
                              ? Colors.white
                              : AppColors.primaryDark,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['name'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isActive ? AppColors.primary : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isLoggedIn = authProvider.isLoggedIn;
    final String? userAvatar = authProvider.user?.avatar;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlobalHeader(),
      body: SafeArea(
        child: FutureBuilder<List<Destination>>(
          future: _futureDestinations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Gagal memuat data: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            final allDestinations = snapshot.data ?? [];

            // BIAR DINAMIS: Filter destinasi berdasarkan kategori aktif yang dipilih user
            final filteredDestinations = allDestinations.where((destination) {
              return destination.category.toLowerCase() ==
                  _selectedCategory.toLowerCase();
            }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureDestinations = ApiService().fetchDestinations();
                });
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    _buildSearchBar(context),
                    const SizedBox(height: 25),

                    _buildSectionTitle(
                      'Kategori Wisata',
                      'Lihat Semua',
                      onActionTap: () => _showAllCategoriesDialog(),
                    ),
                    const SizedBox(height: 15),
                    _buildCategoryList(),
                    const SizedBox(height: 25),

                    _buildSectionTitle('Rekomendasi Untuk Kamu', ''),
                    const SizedBox(height: 15),
                    _buildRecommendationCard(
                      filteredDestinations.isNotEmpty
                          ? filteredDestinations.first
                          : null,
                    ),
                    const SizedBox(height: 25),

                    _buildSectionTitle(
                      'Destinasi Populer',
                      'Eksplor',
                      onActionTap: () {
                        widget.onTabChanged?.call(1);
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildPopularDestinations(filteredDestinations),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            );
          },
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
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExplorePage(searchQuery: query),
                          ),
                        );
                      }
                    },
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Mau liburan kemana hari ini?',
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

  // 3. SECTION TITLE GENERATOR (MENDUKUNG CUSTOM CALLBACK ACTION)
  Widget _buildSectionTitle(
    String title,
    String actionText, {
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        if (actionText.isNotEmpty)
          InkWell(
            onTap:
                onActionTap, // Memanggil fungsi dinamis yang disuntikkan dari atas
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final item = _categories[index];
          final isActive = _selectedCategory == item['name'];

          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = item['name'] as String;
                    });
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: isActive ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppColors.primary : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationCard(Destination? destination) {
    if (destination == null) {
      return Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Tidak ada data rekomendasi untuk kategori ini.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDestinasiScreen(
              destinationId: destination.id ?? 0,
              title: destination.name,
              imageUrl: destination.imageUrl,
              rating: destination.rating.toString(),
              reviewCount: '${destination.reviews} ulasan',
              location: destination.area,
              price: formatRupiah(destination.price),
              distance: '15 mnt',
              openingHours:
                  '${destination.openHour} -\n${destination.closeHour}',
              description:
                  'Nikmati keindahan pesona destinasi wisata terbaik di Banyumas.',
              galleryImages: destination.images.map((img) => img.imageUrl).toList(),
            ),
          ),
        );
      },
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(destination.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.teal, size: 20),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          destination.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              destination.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '•',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '15 mnt',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formatRupiah(destination.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularDestinations(List<Destination> destinations) {
    // Mengambil item ke-2 dan ke-3 dari list terfilter
    final popularList = destinations.skip(1).take(2).toList();

    if (popularList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text(
            'Tidak ada data populer untuk kategori ini.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      );
    }

    return Row(
      children: popularList.map((destination) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailDestinasiScreen(
                    destinationId: destination.id ?? 0,
                    title: destination.name,
                    imageUrl: destination.imageUrl,
                    rating: destination.rating.toString(),
                    reviewCount: '${destination.reviews} ulasan',
                    location: destination.area,
                    price: formatRupiah(destination.price),
                    distance: '5 km',
                    openingHours:
                        '${destination.openHour} -\n${destination.closeHour}',
                    description:
                        'Nikmati keseruan berwisata di tempat terpopuler daerah Banyumas.',
                    galleryImages: destination.images.map((img) => img.imageUrl).toList(),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
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
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(destination.imageUrl),
                            fit: BoxFit.cover,
                          ),
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
                            color: Colors.black.withValues(alpha: 0.4),
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
                                destination.rating.toString(),
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destination.area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatRupiah(destination.price),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/components/filter_bottom_sheet.dart'; // Sesuaikan "dokemas_mobile" dengan nama projekmu
import '../theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Background abu-abu sangat muda
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(context),
              const SizedBox(height: 25),
              _buildSectionTitle('Kategori Wisata', 'Lihat Semua'),
              const SizedBox(height: 15),
              _buildCategoryList(),
              const SizedBox(height: 25),
              _buildSectionTitle('Rekomendasi Untuk Kamu', ''),
              const SizedBox(height: 15),
              _buildRecommendationCard(),
              const SizedBox(height: 25),
              _buildSectionTitle('Destinasi Populer', 'Eksplor'),
              const SizedBox(height: 15),
              _buildPopularDestinations(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
      // Navbar disediakan oleh shell (MainScreen / GuestMainScreen).
    );
  }

  // 1. HEADER SECTION
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Ganti dengan aset foto profil nanti
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'Halo, Saputra ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.location_on, size: 16, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Purwokerto, Jawa Tengah',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_none_outlined,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  // 2. SEARCH BAR SECTION
  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: const [
                Icon(Icons.search, color: AppColors.primary),
                SizedBox(width: 10),
                Text(
                  'Mau liburan kemana hari ini?',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () => showFilterBottomSheet(context), // <--- MEMANGGIL FUNGSI FILTER
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

  // 3. SECTION TITLE GENERATOR
  Widget _buildSectionTitle(String title, String actionText) {
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
          Text(
            actionText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }

  // 4. CATEGORY LIST SECTION
  Widget _buildCategoryList() {
    final categories = [
      {'name': 'Alam', 'icon': Icons.terrain, 'active': true},
      {'name': 'Keluarga', 'icon': Icons.people, 'active': false},
      {'name': 'Kuliner', 'icon': Icons.restaurant, 'active': false},
      {'name': 'Edukasi', 'icon': Icons.school, 'active': false},
      {'name': 'Religi', 'icon': Icons.church, 'active': false},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          final isActive = item['active'] as bool;

          return Padding(
            padding: const EdgeInsets.only(right:15.0),
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: isActive ? Colors.white : AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 5. RECOMMENDATION CARD (Baturraden)
  Widget _buildRecommendationCard() {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/400x250'), // Ganti dengan gambar Baturraden asli nanti
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradien gelap di bawah gambar agar teks terbaca jelas
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Tombol Wishlist Atas Kanan
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.teal, size: 20),
            ),
          ),
          // Informasi Konten di Bawah
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lokawisata Baturraden',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text('4.8', style: TextStyle(color: Colors.white, fontSize: 12)),
                        SizedBox(width: 6),
                        Text('•', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 6),
                        Icon(Icons.directions_car, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('15 mnt', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Rp 25.000',
                    style: TextStyle(
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
    );
  }

  // 6. POPULAR DESTINATIONS SECTION
  Widget _buildPopularDestinations() {
    final destinations = [
      {
        'name': 'Menara Pandang...',
        'location': 'Pusat Kota',
        'price': 'Rp 15.000',
        'rating': '4.9',
      },
      {
        'name': 'Taman Balai...',
        'location': 'Taman Kota',
        'price': 'Rp 10.000',
        'rating': '4.6',
      },
    ];

    return Row(
      children: destinations.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        image: DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/150'), // Ganti gambar asli nanti
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
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              item['rating']!,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
                        item['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['location']!,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['price']!,
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
        );
      }).toList(),
    );
  }
}

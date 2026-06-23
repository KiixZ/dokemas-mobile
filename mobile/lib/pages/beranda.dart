import 'package:flutter/material.dart';
import 'package:mobile/components/filter_bottom_sheet.dart';
import 'package:mobile/pages/detail_destinasi_screen.dart';
import '../theme/app_colors.dart';
import 'notification_page.dart';
import 'package:mobile/pages/explore_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';


// 1. MENGUBAH HOMEPAGE MENJADI STATEFULWIDGET
class HomePage extends StatefulWidget {
  final void Function(int)? onTabChanged;
  const HomePage({Key? key, this.onTabChanged}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel untuk melacak kategori mana yang sedang aktif (Default: 'Alam')
  String _selectedCategory = 'Alam';

  // Data list kategori dipindahkan ke tingkat State agar bisa diakses dinamis
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Alam', 'icon': Icons.terrain},
    {'name': 'Keluarga', 'icon': Icons.people},
    {'name': 'Kuliner', 'icon': Icons.restaurant},
    {'name': 'Edukasi', 'icon': Icons.school},
    {'name': 'Religi', 'icon': Icons.church},
  ];

  // FUNGSI UNTUK MENAMPILKAN POP-UP SEMUA KATEGORI
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
                crossAxisCount: 3, // Menampilkan 3 item per baris
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
                    Navigator.of(context).pop(); // Tutup pop-up setelah memilih
                    print('Kategori Terpilih dari Pop-up: $_selectedCategory');
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
                          color: isActive ? Colors.white : AppColors.primaryDark,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['name'] as String,
                        textAlign: TextAlign.center,
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
              
              // KATEGORI WISATA -> Memunculkan Pop-up Dialog
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
              _buildRecommendationCard(),
              const SizedBox(height: 25),
              
              // DESTINASI POPULER -> Berpindah ke ExplorePage
              _buildSectionTitle(
                'Destinasi Populer', 
                'Eksplor',
                onActionTap: () {
                  // Pindah ke tab Explore (index 1) di MainScreen
                  // agar navbar tetap tampil, bukan Navigator.push
                  widget.onTabChanged?.call(1);
                },
              ),
              const SizedBox(height: 15),
              _buildPopularDestinations(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // 1. HEADER SECTION (TOMBOL NOTIFIKASI AKTIF)
  Widget _buildHeader() {
    final authProvider = context.watch<AuthProvider>();
    final isLoggedIn = authProvider.isLoggedIn;
    final userName = authProvider.user?.name ?? '';

    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    isLoggedIn && userName.isNotEmpty
                        ? 'Halo, $userName '
                        : 'Halo! ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                    ),
                  ),
                  const Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.location_on, size: 16, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Purwokerto, Jawa Tengah',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPage(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
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
        ),
      ],
    );
  }

  // 2. SEARCH BAR SECTION (SUDAH AKTIF & INTERAKTIF)
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
                            builder: (context) => ExplorePage(searchQuery: query),
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
  Widget _buildSectionTitle(String title, String actionText, {VoidCallback? onActionTap}) {
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
            onTap: onActionTap, // Memanggil fungsi dinamis yang disuntikkan dari atas
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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

  // 4. CATEGORY LIST SECTION (SUDAH DIPERBAIKI & INTERAKTIF)
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
                    print('Kategori Terpilih: $_selectedCategory');
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

  // 5. RECOMMENDATION CARD (Baturraden)
  Widget _buildRecommendationCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailDestinasiScreen(
              title: 'Lokawisata Baturraden',
              imageUrl:
                  'https://images.unsplash.com/photo-1546182990-dffeafbe841d?w=500&auto=format&fit=crop',
              rating: '4.8',
              reviewCount: '1.2k ulasan',
              location: 'Baturraden, Banyumas',
              price: 'Rp25.000',
              distance: '15 mnt',
              openingHours: '08:00 -\n17:00',
              description:
                  'Nikmati udara segar pegunungan dan panorama alam yang memukau di Baturraden. Terletak di lereng Gunung Slamet, destinasi ini menawarkan kombinasi sempurna antara air terjun yang jernih, hutan pinus yang rindang, dan sumber air panas alami. Tempat yang ideal untuk melarikan diri dari hiruk-pikuk kota dan menyatu kembali dengan alam.',
            ),
          ),
        );
      },
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: NetworkImage('https://via.placeholder.com/400x250'),
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
                          Text(
                            '4.8',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(width: 6),
                          Text('•', style: TextStyle(color: Colors.white)),
                          SizedBox(width: 6),
                          Icon(
                            Icons.directions_car,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '15 mnt',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
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
      ),
    );
  }

  // 6. POPULAR DESTINATIONS SECTION
  Widget _buildPopularDestinations() {
    final destinations = [
      {
        'name': 'Menara Pandang...',
        'fullName': 'Menara Pandang Purwokerto',
        'location': 'Pusat Kota',
        'fullLocation': 'Purwokerto Timur, Banyumas',
        'price': 'Rp 15.000',
        'rating': '4.9',
        'reviewCount': '856 ulasan',
        'distance': '5 km',
        'openingHours': '09:00 -\n21:00',
        'description':
            'Menara Pandang Purwokerto merupakan landmark ikonik yang menawarkan pemandangan kota Purwokerto dari ketinggian. Cocok untuk menikmati sunset dan suasana kota di malam hari dengan lampu-lampu yang gemerlap.',
      },
      {
        'name': 'Taman Balai...',
        'fullName': 'Taman Balai Kemambang',
        'location': 'Taman Kota',
        'fullLocation': 'Purwokerto Utara, Banyumas',
        'price': 'Rp 10.000',
        'rating': '4.6',
        'reviewCount': '632 ulasan',
        'distance': '3 km',
        'openingHours': '06:00 -\n18:00',
        'description':
            'Taman Balai Kemambang adalah taman kota yang asri dan teduh, cocok untuk bersantai bersama keluarga. Dilengkapi dengan kolam ikan, area bermain anak, dan jogging track yang nyaman.',
      },
    ];

    return Row(
      children: destinations.map((item) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailDestinasiScreen(
                    title: item['fullName']!,
                    rating: item['rating']!,
                    reviewCount: item['reviewCount']!,
                    location: item['fullLocation']!,
                    price: item['price']!,
                    distance: item['distance']!,
                    openingHours: item['openingHours']!,
                    description: item['description']!,
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
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://via.placeholder.com/150',
                            ),
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['location']!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
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
          ),
        );
      }).toList(),
    );
  }
}
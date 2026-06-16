import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Variabel penanda kategori yang sedang aktif (default: 'Alam')
  String _selectedCategory = 'Alam';

  // 2. Data list kategori dengan Icon yang sesuai
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Alam', 'icon': Icons.terrain},
    {'name': 'Keluarga', 'icon': Icons.people},
    {'name': 'Kuliner', 'icon': Icons.restaurant},
    {'name': 'Edukasi', 'icon': Icons.school},
    {'name': 'Religi', 'icon': Icons.church},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildSectionTitle('Kategori Wisata', 'Lihat Semua'),
              const SizedBox(height: 15),
              
              // MEMANGGIL LIST KATEGORI INTERAKTIF
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
    );
  }

  // --- WIDGET HEADER ---
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Halo, Saputra ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff05668d))),
                  Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Color(0xff028090)),
                  SizedBox(width: 4),
                  Text('Purwokerto, Jawa Tengah', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Color(0xffe0f2f1),
            child: Icon(Icons.notifications_none, color: Color(0xff028090)),
          )
        ],
      ),
    );
  }

  // --- WIDGET SEARCH BAR ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Text('Mau liburan kemana hari ini?', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xff028090),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // --- WIDGET JUDUL SEKSI ---
  Widget _buildSectionTitle(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff05668d))),
          if (action.isNotEmpty)
            Text(action, style: const TextStyle(fontSize: 12, color: Color(0xff028090), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- FUNGSI UTAMA: LIST KATEGORI YANG BISA DIKLIK (SUDAH AKTIF) ---
  Widget _buildCategoryList() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['name'];

          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'];
                    });
                    print('Kategori aktif: $_selectedCategory');
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xff028090) : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      category['icon'],
                      color: isSelected ? Colors.white : const Color(0xff05668d),
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xff028090) : Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET REKOMENDASI & POPULER DUMMY ---
  Widget _buildRecommendationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: Text('Card Rekomendasi Wisata')),
    );
  }

  Widget _buildPopularDestinations() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('Destinasi 1')),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('Destinasi 2')),
            ),
          ),
        ],
      ),
    );
  }
}
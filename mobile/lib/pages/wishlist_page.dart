import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/wishlist_card.dart';

/// Halaman Utama Wishlist Saya
/// Menampilkan daftar destinasi favorit yang disimpan oleh pengguna
/// dengan fitur pencarian dan interaksi hapus instan (dengan aksi Undo).
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Data mock destinasi wisata favorit di wilayah Banyumas/Purwokerto
  final List<Map<String, dynamic>> _allFavorites = [
    {
      'id': '1',
      'title': 'Lokawisata Baturraden',
      'category': 'Wisata Alam',
      'location': 'Kec. Baturraden, Banyumas',
      'rating': 4.7,
      'imageUrl': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=2070&auto=format&fit=crop',
    },
    {
      'id': '2',
      'title': 'Menara Pandang Teratai',
      'category': 'Ikon Kota',
      'location': 'Kedungwringin, Purwokerto Selatan',
      'rating': 4.5,
      'imageUrl': 'https://images.unsplash.com/photo-1555899434-94d1368aa7af?q=80&w=2070&auto=format&fit=crop',
    },
    {
      'id': '3',
      'title': 'Curug Bayan',
      'category': 'Wisata Alam',
      'location': 'Ketenger, Baturraden',
      'rating': 4.6,
      'imageUrl': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=2070&auto=format&fit=crop',
    },
    {
      'id': '4',
      'title': 'Soto Sokaraja H. Loso',
      'category': 'Kuliner',
      'location': 'Sokaraja, Banyumas',
      'rating': 4.8,
      'imageUrl': 'https://images.unsplash.com/photo-1548943487-a2e4f43b4850?q=80&w=2070&auto=format&fit=crop',
    },
  ];

  late List<Map<String, dynamic>> _favorites;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _favorites = List.from(_allFavorites);
  }

  // Filter pencarian berdasarkan nama, kategori, atau lokasi
  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _favorites = List.from(_allFavorites);
      } else {
        _favorites = _allFavorites
            .where((item) =>
                item['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
                item['category'].toString().toLowerCase().contains(query.toLowerCase()) ||
                item['location'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Menghapus item dari favorit dengan animasi/dialog Undo
  void _removeFavorite(Map<String, dynamic> item, int index) {
    setState(() {
      _favorites.removeAt(index);
      _allFavorites.removeWhere((element) => element['id'] == item['id']);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['title']} dihapus dari Wishlist'),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        action: SnackBarAction(
          label: 'Batal',
          textColor: AppColors.accent,
          onPressed: () {
            setState(() {
              _favorites.insert(index, item);
              _allFavorites.add(item);
            });
          },
        ),
      ),
    );
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
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        titleSpacing: AppSpacing.md,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari destinasi favorit...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyles.title,
                onChanged: _filterSearch,
              )
            : Text(
                'Wishlist Saya',
                style: AppTextStyles.heading1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _favorites = List.from(_allFavorites);
                } else {
                  _isSearching = true;
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: _favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 72,
                      color: AppColors.textMuted.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Belum ada destinasi favorit',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Silakan jelajahi tempat-tempat menarik dan tekan ikon hati untuk menyimpannya di sini.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final item = _favorites[index];
                return WishlistCard(
                  key: ValueKey(item['id']),
                  title: item['title'],
                  category: item['category'],
                  location: item['location'],
                  rating: item['rating'],
                  imageUrl: item['imageUrl'],
                  isFavorite: true,
                  onFavoritePressed: () => _removeFavorite(item, index),
                  onTap: () {
                    // Tindakan saat kartu ditekan (bisa navigasi detail di masa depan)
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Membuka detail ${item['title']} (Placeholder)'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
      // Navbar disediakan oleh shell (MainScreen).
    );
  }
}

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
      'imageUrl':
          'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=2070&auto=format&fit=crop',
      'description':
          'Lokawisata Baturraden menawarkan pemandangan alam lereng Gunung Slamet yang asri, dilengkapi dengan air terjun, pemandian air panas alami, dan spot foto modern yang sangat cocok untuk liburan keluarga.',
      'reviews': [
        {
          'user': 'Aditya',
          'comment': 'Tempatnya sejuk banget, air terjunnya bersih!',
          'stars': 5,
        },
        {
          'user': 'Rian',
          'comment': 'Sangat ramah anak, cuma kalau weekend agak ramai.',
          'stars': 4,
        },
      ],
    },
    {
      'id': '2',
      'title': 'Menara Pandang Teratai',
      'category': 'Ikon Kota',
      'location': 'Kedungwringin, Purwokerto Selatan',
      'rating': 4.5,
      'imageUrl':
          'https://images.unsplash.com/photo-1555899434-94d1368aa7af?q=80&w=2070&auto=format&fit=crop',
      'description':
          'Menara Pandang Teratai adalah landmark baru setinggi 117 meter di jantung kota Purwokerto yang menyajikan keindahan lanskap kota dari ketinggian, terutama pesona lampu kota di malam hari.',
      'reviews': [
        {
          'user': 'Siti',
          'comment': 'View malam hari dari atas menara luar biasa!',
          'stars': 5,
        },
        {
          'user': 'Budi',
          'comment': 'Jembatan kacanya seru sekaligus bikin merinding.',
          'stars': 4,
        },
      ],
    },
    {
      'id': '3',
      'title': 'Curug Bayan',
      'category': 'Wisata Alam',
      'location': 'Ketenger, Baturraden',
      'rating': 4.6,
      'imageUrl':
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=2070&auto=format&fit=crop',
      'description':
          'Curug Bayan memiliki karakteristik air terjun yang tidak terlalu tinggi dengan kolam alami yang dangkal dan dikelilingi jeram bebatuan, menjadikannya lokasi favorit yang aman untuk bermain air.',
      'reviews': [
        {
          'user': 'Saputra',
          'comment': 'Aksesnya gampang dekat dengan jalan raya dan homestay.',
          'stars': 5,
        },
        {
          'user': 'Dewi',
          'comment': 'Airnya dingin dan segar khas pegunungan.',
          'stars': 4,
        },
      ],
    },
    {
      'id': '4',
      'title': 'Soto Sokaraja H. Loso',
      'category': 'Kuliner',
      'location': 'Sokaraja, Banyumas',
      'rating': 4.8,
      'imageUrl':
          'https://images.unsplash.com/photo-1548943487-a2e4f43b4850?q=80&w=2070&auto=format&fit=crop',
      'description':
          'Kuliner legendaris khas Banyumas dengan ciri khas kuah kaldu sapi gurih yang dipadukan dengan ketupat, kerupuk cantir merah, serta bumbu kacang manis gurih yang khas.',
      'reviews': [
        {
          'user': 'Fajar',
          'comment': 'Daging sapinya empuk, bumbu kacangnya juara!',
          'stars': 5,
        },
        {
          'user': 'Dinda',
          'comment': 'Porsi pas, pelayanannya cepat banget.',
          'stars': 5,
        },
      ],
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
            .where(
              (item) =>
                  item['title'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  item['category'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  item['location'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  // TARUH KODE INI DI ATAS WIDGET BUILD
  void _showDetailModal(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Membuat modal fleksibel mengikuti ukuran konten
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (context) {
        // Ambil data ulasan, jika tidak ada set ke array kosong
        final List reviews = item['reviews'] ?? [];

        return DraggableScrollableSheet(
          initialChildSize: 0.75, // Mengambil 75% tinggi layar saat dibuka
          maxChildSize: 0.9, // Batas maksimal geser ke atas (90% layar)
          minChildSize: 0.5, // Batas minimal geser ke bawah
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Batang penanda geser modal (Handle Bar)
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Foto Utama Destinasi
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Image.network(
                      item['imageUrl'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Judul & Kategori
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['title'],
                          style: AppTextStyles.heading2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                        ),
                        child: Text(
                          item['category'],
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Lokasi & Rating singkat
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['location'],
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${item['rating']}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.xl),

                  // Bagian Deskripsi
                  Text(
                    'Deskripsi',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item['description'] ??
                        'Info deskripsi destinasi wisata ini akan segera diperbarui.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const Divider(height: AppSpacing.xl),

                  // Bagian Ulasan Pengguna
                  Text(
                    'Ulasan Pengguna (${reviews.length})',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  reviews.isEmpty
                      ? Text(
                          'Belum ada ulasan untuk tempat ini.',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textMuted,
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, rIndex) {
                            final rev = reviews[rIndex];
                            return Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSm,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        rev['user'],
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          rev['stars'],
                                          (index) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    rev['comment'],
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Menghapus item dari favorit dengan animasi/dialog Undo
  void _removeFavorite(Map<String, dynamic> item) {
    final int targetIndex = _favorites.indexWhere(
      (element) => element['id'] == item['id'],
    );

    if (targetIndex != -1) {
      // Selalu bersihkan SnackBar yang sedang aktif sebelum memunculkan yang baru
      ScaffoldMessenger.of(context).clearSnackBars();

      setState(() {
        _favorites.removeAt(targetIndex);
        _allFavorites.removeWhere((element) => element['id'] == item['id']);
      });

      // Tampilkan SnackBar baru
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['title']} dihapus dari Wishlist'),
          duration: const Duration(seconds: 4), // Durasi tampil 4 detik
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          action: SnackBarAction(
            label: 'Batal',
            textColor: AppColors.accent,
            onPressed: () {
              setState(() {
                _favorites.insert(targetIndex, item);
                _allFavorites.insert(targetIndex, item);
              });
              // Jika tombol Batal ditekan, langsung hapus SnackBar saat itu juga
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );

      // Membuat timer manual 4 detik untuk memaksa SnackBar hilang otomatis
      Future.delayed(const Duration(seconds: 4), () {
        // Cek apakah widget halaman ini masih aktif/terpasang di layar
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
        }
      });
    }
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
                  onFavoritePressed: () => _removeFavorite(item),
                  onTap: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    _showDetailModal(item);
                  },
                );
              },
            ),
      // Navbar disediakan oleh shell (MainScreen).
    );
  }
}

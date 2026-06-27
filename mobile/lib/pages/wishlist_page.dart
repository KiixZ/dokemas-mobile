import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/wishlist_card.dart';
import '../providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';
import '../models/destination.dart';
import 'detail_destinasi_screen.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWishlists();
    });
  }

  Future<void> _fetchWishlists() async {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      await context.read<WishlistProvider>().fetchWishlist(token);
    }
  }

  void _filterSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _removeFavorite(Destination item) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    
    final wishlistProvider = context.read<WishlistProvider>();

    try {
      bool result = await wishlistProvider.toggleWishlist(token, item.id!);
      if (!result && mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} dihapus dari Wishlist'),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            action: SnackBarAction(
              label: 'Batal',
              textColor: AppColors.accent,
              onPressed: () {
                wishlistProvider.toggleWishlist(token, item.id!);
                ScaffoldMessenger.of(context).clearSnackBars();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah wishlist, silakan coba lagi.'),
            backgroundColor: Colors.redAccent,
          )
        );
      }
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
                  _searchQuery = "";
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
      body: Consumer<WishlistProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.errorMessage != null && provider.wishlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  ElevatedButton(
                    onPressed: _fetchWishlists,
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          }

          final List<Destination> filteredWishlist = _searchQuery.isEmpty
              ? provider.wishlist
              : provider.wishlist
                  .where((item) =>
                      item.name.toLowerCase().contains(_searchQuery) ||
                      item.category.toLowerCase().contains(_searchQuery) ||
                      item.area.toLowerCase().contains(_searchQuery))
                  .toList();

          if (filteredWishlist.isEmpty) {
            return Center(
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
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            itemCount: filteredWishlist.length,
            itemBuilder: (context, index) {
              final item = filteredWishlist[index];
              return WishlistCard(
                key: ValueKey(item.id),
                title: item.name,
                category: item.category,
                location: item.area,
                rating: item.rating,
                imageUrl: item.imageUrl,
                isFavorite: true,
                onFavoritePressed: () => _removeFavorite(item),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailDestinasiScreen(
                        destinationId: item.id!,
                        title: item.name,
                        imageUrl: item.imageUrl,
                        rating: item.rating.toString(),
                        reviewCount: item.reviews.toString(),
                        location: item.area,
                        price: item.price.toString(),
                        distance: '0 km', // Dummy
                        openingHours: '${item.openHour} - ${item.closeHour}',
                        description: item.description,
                        galleryImages: item.images.map((img) => img.imageUrl).toList(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/guest_login_required_page.dart';

class GuestWishlistPage extends StatelessWidget {
  const GuestWishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GuestLoginRequiredPage(
      icon: Icons.favorite_border,
      title: 'Wishlist Saya',
      description:
          'Simpan destinasi impianmu dengan\nmasuk ke akun Explore Purwokerto.',
    );
  }
}
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/guest/guest_wishlist_page.dart';
import 'pages/guest/guest_itinerary_page.dart';
import 'pages/guest/guest_profile_page.dart';

void main() {
  runApp(const DokemasApp());
}

class DokemasApp extends StatelessWidget {
  const DokemasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOKEMAS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/guest-profile',
      routes: {
        '/guest-wishlist': (_) => const GuestWishlistPage(),
        '/guest-itinerary': (_) => const GuestItineraryPage(),
        '/guest-profile': (_) => const GuestProfilePage(),
      },
    );
  }
}

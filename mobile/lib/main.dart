import 'package:flutter/material.dart';
import 'pages/guest/guest_profile_page.dart';
import 'pages/guest/guest_wishlist_page.dart';
import 'pages/guest/guest_itinerary_page.dart';

void main() {
  runApp(const DokemasApp());
}

class DokemasApp extends StatelessWidget {
  const DokemasApp({super.key});

  Route<dynamic> _noAnimationRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/guest-wishlist') {
          return _noAnimationRoute(const GuestWishlistPage());
        }

        if (settings.name == '/guest-itinerary') {
          return _noAnimationRoute(const GuestItineraryPage());
        }

        if (settings.name == '/guest-profile') {
          return _noAnimationRoute(const GuestProfilePage());
        }

        return _noAnimationRoute(const GuestProfilePage());
      },
      home: const GuestProfilePage(),
    );
  }
}
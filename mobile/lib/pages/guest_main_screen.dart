import 'package:flutter/material.dart';
import 'beranda.dart';
import 'explore_page.dart';
import 'guest/guest_wishlist_page.dart';
import 'guest/guest_itinerary_page.dart';
import 'guest/guest_profile_page.dart';

/// Shell untuk user BELUM login.
/// Home & Explore bebas; Wishlist/Itinerary/Profile ke-gate (harus login).
class GuestMainScreen extends StatefulWidget {
  const GuestMainScreen({super.key});

  @override
  State<GuestMainScreen> createState() => _GuestMainScreenState();
}

class _GuestMainScreenState extends State<GuestMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(), // 0 Home
    ExplorePage(), // 1 Explore
    GuestWishlistPage(), // 2 Wishlist (gated)
    GuestItineraryPage(), // 3 Itinerary (gated)
    GuestProfilePage(), // 4 Profile (gated)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xff028090),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Itinerary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

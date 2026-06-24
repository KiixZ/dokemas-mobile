import 'package:flutter/material.dart';
import 'beranda.dart'; // Import halaman beranda kamu
import 'explore_page.dart'; // Import halaman explore kamu
import 'wishlist_page.dart';
import 'itinerary_list_page.dart';
import 'profile_page.dart';

// Import halaman guest
import 'guest/guest_wishlist_page.dart';
import 'guest/guest_itinerary_page.dart';
import 'guest/guest_profile_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan status login dari AuthProvider
    final bool isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    final List<Widget> pages = isLoggedIn
        ? [
            HomePage(onTabChanged: _switchTab), // Index 0 (Home)
            const ExplorePage(), // Index 1 (Explore)
            const WishlistPage(), // Index 2 (Favorite/Wishlist)
            const ItineraryListPage(), // Index 3 (Itinerary)
            const ProfilePage(), // Index 4 (Profile)
          ]
        : [
            HomePage(onTabChanged: _switchTab), // Index 0 (Home)
            const ExplorePage(), // Index 1 (Explore)
            const GuestWishlistPage(), // Index 2 (Guest Wishlist)
            const GuestItineraryPage(), // Index 3 (Guest Itinerary)
            const GuestProfilePage(), // Index 4 (Guest Profile)
          ];

    return Scaffold(
      // Body akan otomatis berubah mengikuti tombol yang ditekan
      body: pages[_currentIndex],

      // Bottom Navigation Bar tunggal yang mengontrol semua halaman
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xff028090),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _currentIndex, // Index halaman aktif saat ini
        onTap: _switchTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
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

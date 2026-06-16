import 'package:flutter/material.dart';
import 'beranda.dart';       // Import halaman beranda kamu
import 'explore_page.dart';  // Import halaman explore kamu
import 'wishlist_page.dart';
import 'itinerary_page.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai index tab bawah
  final List<Widget> _pages = const [
    HomePage(),      // Index 0 (Home)
    ExplorePage(),   // Index 1 (Explore)
    WishlistPage(),  // Index 2 (Favorite/Wishlist)
    ItineraryPage(), // Index 3 (Itinerary)
    ProfilePage(),   // Index 4 (Profile)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan otomatis berubah mengikuti tombol yang ditekan
      body: _pages[_currentIndex],
      
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
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mengubah halaman saat di-tap
          });
        },
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
            label: 'Favorite',
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
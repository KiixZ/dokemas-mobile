import 'package:flutter/material.dart';
import 'beranda.dart';       // Import halaman beranda kamu
import 'explore_page.dart';  // Import halaman explore kamu

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai index tab bawah
  final List<Widget> _pages = [
    const HomePage(),    // Index 0 (Home)
    const ExplorePage(), // Index 1 (Explore)
    const Center(child: Text('Halaman Favorite (Belum Dibuat)')),  // Index 2
    const Center(child: Text('Halaman Itinerary (Belum Dibuat)')), // Index 3
    const Center(child: Text('Halaman Profile (Belum Dibuat)')),   // Index 4
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
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'dashboard_page.dart';

/// Shell admin: AppBar (back + judul + notif) + bottom navbar.
/// Body ganti sesuai tab. UI only, belum konek backend.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  static const _titles = [
    'Explore Purwokerto',
    'Destinasi',
    'Kategori',
    'Review',
    'Itinerary',
    'Profil',
  ];

  // Tiap tab isi body-nya (tanpa Scaffold). Placeholder dulu kecuali Dashboard.
  final _pages = const [
    AdminDashboardPage(),
    _Placeholder(label: 'Kelola Destinasi'),
    _Placeholder(label: 'Kelola Kategori'),
    _Placeholder(label: 'Kelola Review'),
    _Placeholder(label: 'Itinerary'),
    _Placeholder(label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _AdminSidebar(
        onDashboard: () {
          Navigator.of(context).pop();
          setState(() => _index = 0);
        },
        onLogout: () => Navigator.of(context).pop(),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          _titles[_index],
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.onPrimary),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.terrain_outlined),
            selectedIcon: Icon(Icons.terrain, color: AppColors.primary),
            label: 'Destinasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category, color: AppColors.primary),
            label: 'Kategori',
          ),
          NavigationDestination(
            icon: Icon(Icons.rate_review_outlined),
            selectedIcon: Icon(Icons.rate_review, color: AppColors.primary),
            label: 'Review',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route, color: AppColors.primary),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String label;
  const _Placeholder({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label\n(belum dibuat)',
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}

/// Sidebar admin ringkas: ke Dashboard atau Logout.
class _AdminSidebar extends StatelessWidget {
  final VoidCallback onDashboard;
  final VoidCallback onLogout;

  const _AdminSidebar({required this.onDashboard, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.onPrimary,
                    child: Icon(Icons.terrain, color: AppColors.primary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'DOKEMAS Admin',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined,
                  color: AppColors.primary),
              title: const Text('Dashboard'),
              onTap: onDashboard,
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.danger),
              title: const Text('Logout',
                  style: TextStyle(color: AppColors.danger)),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

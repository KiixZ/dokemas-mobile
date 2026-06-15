import 'dart:math' as math;

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
          ? _ExpandableFab(
              actions: [
                _FabAction(
                  icon: Icons.person_add_alt,
                  label: 'Tambah User',
                  onTap: () {},
                ),
                _FabAction(
                  icon: Icons.add_location_alt_outlined,
                  label: 'Tambah Destinasi',
                  onTap: () {},
                ),
                _FabAction(
                  icon: Icons.category_outlined,
                  label: 'Tambah Kategori',
                  onTap: () {},
                ),
                _FabAction(
                  icon: Icons.add_business_outlined,
                  label: 'Tambah Fasilitas',
                  onTap: () {},
                ),
              ],
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

/// Data satu aksi di speed-dial FAB.
class _FabAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _FabAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// FAB yang saat ditekan mekar jadi beberapa mini-FAB berlabel.
class _ExpandableFab extends StatefulWidget {
  final List<_FabAction> actions;
  const _ExpandableFab({required this.actions});

  @override
  State<_ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<_ExpandableFab>
    with SingleTickerProviderStateMixin {
  // Ukuran kotak overlay: cukup buat radius arc + tombol.
  static const double _radius = 124;
  static const double _box = 200;

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );
  late final Animation<double> _anim =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  bool _open = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final actions = widget.actions;
    return SizedBox(
      width: _box,
      height: _box,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          // Tiap aksi disebar di arc kuadran kiri-atas, muterin tombol +.
          for (int i = 0; i < actions.length; i++)
            _arcItem(actions[i], i, actions.length),
          // Tombol utama, tetap di pojok kanan-bawah.
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              heroTag: '_fabMain',
              onPressed: _toggle,
              backgroundColor: AppColors.primary,
              child: AnimatedRotation(
                turns: _open ? 0.125 : 0, // + -> x saat terbuka
                duration: const Duration(milliseconds: 240),
                child: const Icon(Icons.add, color: AppColors.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _arcItem(_FabAction a, int i, int count) {
    // Sudut dari 90 deg (atas) ke 180 deg (kiri), rata sepanjang busur.
    final t = count == 1 ? 0.5 : i / (count - 1);
    final angle = (90 + t * 90) * math.pi / 180; // radian
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final v = _anim.value.clamp(0.0, 1.0);
        final dx = _radius * v * -math.cos(angle); // ke kiri
        final dy = _radius * v * math.sin(angle); // ke atas
        // Pusat tombol + ~ 28px dari tiap tepi; mini-fab 48 -> offset 24.
        return Positioned(
          right: 28 + dx - 20,
          bottom: 28 + dy - 20,
          child: Transform.scale(
            scale: v,
            child: Opacity(opacity: v, child: child),
          ),
        );
      },
      child: FloatingActionButton.small(
        heroTag: a.label,
        tooltip: a.label,
        onPressed: () {
          _toggle();
          a.onTap();
        },
        backgroundColor: AppColors.primary,
        child: Icon(a.icon, color: AppColors.onPrimary),
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

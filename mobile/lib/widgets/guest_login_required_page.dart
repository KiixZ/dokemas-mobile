import 'package:flutter/material.dart';

class GuestLoginRequiredPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int selectedIndex;

  const GuestLoginRequiredPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 155),
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAF2FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Icon(
                          icon,
                          size: 43,
                          color: const Color(0xFF00796B),
                        ),
                        Positioned(
                          top: 5,
                          right: 4,
                          child: Container(
                            width: 19,
                            height: 19,
                            decoration: const BoxDecoration(
                              color: Color(0xFF19C7B7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 62),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF102033),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.55,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7B8493),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00796B),
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 17),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7B8493),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF00796B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _GuestBottomNav(selectedIndex: selectedIndex),
          ],
        ),
      ),
    );
  }
}

class _GuestBottomNav extends StatelessWidget {
  final int selectedIndex;

  const _GuestBottomNav({
    required this.selectedIndex,
  });

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) return;

    if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/guest-wishlist',
        (route) => false,
      );
    } else if (index == 3) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/guest-itinerary',
        (route) => false,
      );
    } else if (index == 4) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/guest-profile',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final menus = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.search, 'label': 'Search'},
      {'icon': Icons.favorite_border, 'label': 'Wishlist'},
      {'icon': Icons.calendar_month_outlined, 'label': 'Itinerary'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      height: 61,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE9EDF3), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(menus.length, (index) {
          final isActive = index == selectedIndex;

          return GestureDetector(
            onTap: () => _navigate(context, index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  menus[index]['icon'] as IconData,
                  size: 20,
                  color: isActive
                      ? const Color(0xFF00796B)
                      : const Color(0xFF8C97A6),
                ),
                const SizedBox(height: 3),
                Text(
                  menus[index]['label'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    color: isActive
                        ? const Color(0xFF00796B)
                        : const Color(0xFF8C97A6),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/date_selector.dart';
import '../widgets/timeline_item.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  // Generate mock dates
  final List<DateTime> _dates = List.generate(
    7,
    (index) => DateTime.now().subtract(const Duration(days: 2)).add(Duration(days: index)),
  );
  
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Default select "today"
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: AppSpacing.md,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=11', // Placeholder profile pic
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            RichText(
              text: TextSpan(
                style: AppTextStyles.title,
                children: const [
                  TextSpan(text: 'Halo, '),
                  TextSpan(
                    text: 'Saputra ',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: '👋'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Rencana Perjalanan',
                    style: AppTextStyles.heading1.copyWith(
                      color: const Color(0xFF0F172A), // Sangat gelap untuk judul utama
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Purwokerto, Jawa Tengah',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),

            // Date Selector
            DateSelector(
              dates: _dates,
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            
            const SizedBox(height: AppSpacing.lg),

            // Timeline Items
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  TimelineItem(
                    time: '08:00',
                    title: 'Lokawisata Baturraden',
                    category: 'Wisata Alam',
                    categoryIcon: Icons.park,
                    distanceText: '45 mnt (15 km) dari pusat kota',
                    imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=2070&auto=format&fit=crop',
                  ),
                  TimelineItem(
                    time: '12:00',
                    title: 'Soto Sokaraja H. Loso',
                    category: 'Makan Siang',
                    categoryIcon: Icons.restaurant,
                    distanceText: '20 mnt (8 km) perjalanan',
                    imageUrl: 'https://images.unsplash.com/photo-1548943487-a2e4f43b4850?q=80&w=2070&auto=format&fit=crop',
                  ),
                  TimelineItem(
                    time: '15:00',
                    title: 'Menara Pandang Teratai',
                    category: 'Ikon Kota',
                    categoryIcon: Icons.location_city,
                    distanceText: '10 mnt (1.5 km) dari restoran',
                    imageUrl: 'https://images.unsplash.com/photo-1555899434-94d1368aa7af?q=80&w=2070&auto=format&fit=crop',
                  ),
                  TimelineItem(
                    time: '19:00',
                    title: 'Alun-alun Purwokerto',
                    category: 'Kuliner Malam',
                    categoryIcon: Icons.nightlight_round,
                    distanceText: 'Jalan kaki (Dekat area menara)',
                    imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      // Navbar disediakan oleh shell (MainScreen).
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/admin/dashboard_provider.dart';
import 'providers/itinerary_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/review_provider.dart';
import 'theme/app_theme.dart';
import 'pages/splash_screen.dart';

void main() {
  runApp(const DokemasApp());
}

class DokemasApp extends StatelessWidget {
  const DokemasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ItineraryProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: MaterialApp(
        title: 'DOKEMAS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}

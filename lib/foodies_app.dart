import 'package:flutter/material.dart';
import 'package:foodies/config/routes.dart';
import 'package:foodies/main.dart';

import 'package:foodies/ui_screens/user/splash_screen.dart';

class FoodieApp extends StatefulWidget {
  const FoodieApp({super.key});

  @override
  State<FoodieApp> createState() => _FoodieAppState();
}

class _FoodieAppState extends State<FoodieApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: _buildTheme(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          default:
            return AppRoutes.generateRoute(settings);
        }
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF1A9E5E),
        onPrimary: Colors.white,
        secondary: const Color(0xFF5E9E1A),
      ),
      useMaterial3: true,
    );
  }
}

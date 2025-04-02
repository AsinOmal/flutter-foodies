import 'package:flutter/material.dart';
import 'package:foodies/config/routes.dart';
import 'package:foodies/providers/auth_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for both splash duration and auth check
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      _waitForAuthCheck(),
    ]);

    if (!mounted) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    Navigator.pushReplacementNamed(
      context,
      auth.user != null ? AppRoutes.home : AppRoutes.login,
    );
  }

  Future<void> _waitForAuthCheck() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    while (auth.initialCheck) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/splash_animation.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            Text(
              'Foodies',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 5),
            Text(
              'Foodies – Fast, Fresh, Delivered!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        ),
      ),
    );
  }
}

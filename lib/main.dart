import 'package:flutter/material.dart';
import 'package:foodies/ui_screens/user/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1A9E5E),
          onPrimary: Colors.white,
          secondary: const Color(0xFF5E9E1A),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
    
  }
}

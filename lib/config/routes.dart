import 'package:flutter/material.dart';
import 'package:foodies/models/restaurant.dart';
import 'package:foodies/ui_screens/user/home_screen.dart';
import 'package:foodies/ui_screens/user/restaurant_details_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String restaurantDetails = '/restaurant_details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case restaurantDetails:
        final restaurant = settings.arguments as Restaurant;
        return MaterialPageRoute(
          builder: (context) => RestaurantDetailsScreen(restaurant: restaurant),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                Center(
                  child: AlertDialog(
                    title: Text('No Navigation Defined'),
                    content: Text('No Route for ${settings.name}'),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}

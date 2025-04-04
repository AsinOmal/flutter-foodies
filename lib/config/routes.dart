import 'package:flutter/material.dart';
import 'package:foodies/models/restaurant.dart';
import 'package:foodies/providers/auth_provider.dart';
import 'package:foodies/ui_screens/user/auth/forgot_password_screen.dart';
import 'package:foodies/ui_screens/user/auth/login_screen.dart';
import 'package:foodies/ui_screens/user/auth/signup_screen.dart';
import 'package:foodies/ui_screens/user/auth/verification_pending_screen.dart';
import 'package:foodies/ui_screens/user/cart_screen.dart';
import 'package:foodies/ui_screens/user/home_screen.dart';
import 'package:foodies/ui_screens/user/order_confirmation_screen.dart';
import 'package:foodies/ui_screens/user/order_sucesss_screen.dart';
import 'package:foodies/ui_screens/user/profile_screen.dart';
import 'package:foodies/ui_screens/user/restaurant_details_screen.dart';
import 'package:foodies/ui_screens/user/splash_screen.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String restaurantDetails = '/restaurant-details';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderSuccess = '/order-success';
  static const String verifyEmail = '/verify-email';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(
          builder: (context) {
            final auth = Provider.of<AuthProvider>(context);
            return auth.user != null ? const HomeScreen() : const LoginScreen();
          },
        );
        
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case restaurantDetails:
        final restaurant = settings.arguments as Restaurant;
        return MaterialPageRoute(
          builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
        );
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case orderConfirmation:
        return MaterialPageRoute(
            builder: (_) => const OrderConfirmationScreen());
      case orderSuccess:
        return MaterialPageRoute(builder: (_) => const OrderSuccessScreen());
      case AppRoutes.verifyEmail:
        return MaterialPageRoute(
            builder: (_) => const VerificationPendingScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

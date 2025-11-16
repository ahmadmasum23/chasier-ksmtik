import 'package:flutter/material.dart';

// Import screens that don't cause circular dependencies
import 'package:kasir_kosmetic/ui/screens/splash_screen.dart';
import 'package:kasir_kosmetic/ui/screens/login_screen.dart';
import 'package:kasir_kosmetic/ui/screens/dashboard_screen.dart';
import 'package:kasir_kosmetic/ui/screens/chasier.dart';
import 'package:kasir_kosmetic/ui/screens/onboarding_screen.dart';

// For screens with potential circular dependencies, we use a deferred loading approach
// This avoids direct imports that could cause issues

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String cashier = '/cashier';
  static const String products = '/products';
  static const String customers = '/customers';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case cashier:
        return MaterialPageRoute(builder: (_) => const CashierScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case signup:
        return _buildSignupScreen();
      case products:
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Products Screen')),
        ));
      case customers:
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Customers Screen')),
        ));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute _buildSignupScreen() {
    return MaterialPageRoute(builder: (_) => const _PlaceholderScreen('Signup Screen'));
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Text('This screen needs to be properly implemented'),
            const SizedBox(height: 20),
            const Text('Note: Circular dependencies prevented direct import'),
          ],
        ),
      ),
    );
  }
}
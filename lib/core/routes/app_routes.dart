import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/features/auth/screens/login_screen.dart';
import 'package:kasir_kosmetic/features/cashier/screens/cashier_screen.dart';
import 'package:kasir_kosmetic/features/customer_management/screens/customer_list_screen.dart';
import 'package:kasir_kosmetic/features/dashboard/screens/dashboard_screen.dart';
import 'package:kasir_kosmetic/features/onboarding/screens/onboarding_screen.dart';
import 'package:kasir_kosmetic/features/onboarding/screens/splash_screen.dart';
import 'package:kasir_kosmetic/features/product_management/screens/product_list_screen.dart';
import 'package:kasir_kosmetic/features/sales_report/screens/sales_report_screen.dart';
import 'package:kasir_kosmetic/features/stock/screens/stock_screen.dart';
import 'package:kasir_kosmetic/features/auth/screens/signup_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String cashier = '/cashier';
  static const String products = '/products';
  static const String customers = '/customers';
  static const String stock = '/stock';
  static const String salesReport = '/sales-report';

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
      case products:
        return MaterialPageRoute(builder: (_) => const ProductManagementScreen());
      case customers:
        return MaterialPageRoute(builder: (_) => const CustomerManagementScreen());
      case stock:
        return MaterialPageRoute(builder: (_) => const StockProductScreen());
      case salesReport:
        return MaterialPageRoute(builder: (_) => const SalesReportScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
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
} 
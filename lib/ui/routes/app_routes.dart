import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/ui/screens/chasier/chasier.dart';
import 'package:kasir_kosmetic/ui/screens/dashboard/dashboard.dart';

import 'package:kasir_kosmetic/ui/screens/customer_management_screen.dart';
import 'package:kasir_kosmetic/ui/screens/management_produk.dart';
import 'package:kasir_kosmetic/ui/screens/stock_product_screen.dart';
import 'package:kasir_kosmetic/ui/screens/sales_report_screen.dart';
import 'package:kasir_kosmetic/ui/screens/splash_screen.dart';
import 'package:kasir_kosmetic/ui/screens/login_screen.dart';
import 'package:kasir_kosmetic/ui/screens/onboarding_screen.dart';

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
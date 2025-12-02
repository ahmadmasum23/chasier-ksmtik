import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:kasir_kosmetic/features/customer_management/screens/customer_management_screen.dart';
import 'package:kasir_kosmetic/features/dashboard/screens/dashboard_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'features/onboarding/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kasir Kosmetic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
      home: const SplashScreen(),
      // home: const DashboardScreen(),
      // home: CustomerManagementScreen(),
    );
  }
}
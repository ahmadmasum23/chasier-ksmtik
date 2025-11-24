import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/features/sales_report/screens/sales_report_screen.dart';
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
      // home: const SplashScreen(),
      home: const SalesReportScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/core/routes/app_routes.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _currentRoute = '';

  @override
  void initState() {
    super.initState();
    _updateCurrentRoute();
  }

  void _updateCurrentRoute() {
    // Mendapatkan route saat ini
    final currentRoute = Get.currentRoute;
    setState(() {
      _currentRoute = currentRoute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header dengan background pink
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.softPink,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo atau icon toko yang lebih besar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.store,
                      color: AppColors.softPink,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Teks di sebelah kanan icon
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama aplikasi yang lebih besar
                        const Text(
                          'Beauty POS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Role admin yang lebih besar
                        const Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: AppRoutes.dashboard,
                  onTap: () {
                    _navigateToRoute(AppRoutes.dashboard);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.point_of_sale,
                  title: 'Kasir',
                  route: AppRoutes.cashier,
                  onTap: () {
                    _navigateToRoute(AppRoutes.cashier);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.inventory_2,
                  title: 'Produk',
                  route: AppRoutes.products,
                  onTap: () {
                    _navigateToRoute(AppRoutes.products);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.people,
                  title: 'Pelanggan',
                  route: AppRoutes.customers,
                  onTap: () {
                    _navigateToRoute(AppRoutes.customers);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.inventory,
                  title: 'Stok',
                  route: AppRoutes.stock,
                  onTap: () {
                    _navigateToRoute(AppRoutes.stock);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.bar_chart,
                  title: 'Laporan',
                  route: AppRoutes.salesReport,
                  onTap: () {
                    _navigateToRoute(AppRoutes.salesReport);
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Menu Admin
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                _buildMenuItem(
                  icon: Icons.person_add,
                  title: 'Tambah User',
                  route: AppRoutes.signup,
                  onTap: () {
                    _navigateToRoute(AppRoutes.signup);
                  },
                ),
              ],
            ),
          ),
          
          // Logout button di bagian bawah
          Container(
            padding: const EdgeInsets.all(16),
            child: _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              route: '/logout', // Route khusus untuk logout
              onTap: () {
                Get.back();
                // Tambahkan logika logout di sini
              },
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
    required VoidCallback onTap,
    Color? color,
  }) {
    final isActive = _currentRoute == route;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.softPink.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: color ?? (isActive ? AppColors.softPink : Colors.black87),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? (isActive ? AppColors.softPink : Colors.black87),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _navigateToRoute(String route) {
    Get.back();
    Get.offAllNamed(route);
    // Update current route setelah navigasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCurrentRoute();
    });
  }
}
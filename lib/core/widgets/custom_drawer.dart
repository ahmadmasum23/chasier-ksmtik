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


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color:AppColors.softPink),
            child: Center(
              child: Text(
                'Kasir Kosmetik',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Search bar
          _item(Icons.dashboard, 'Dashboard', () {
            Get.back();
            Get.offAllNamed(AppRoutes.dashboard);
          }),
          _item(Icons.point_of_sale, 'Kasir', () {
            Get.back();
            Get.offAllNamed(AppRoutes.cashier);
          }),
          _item(Icons.inventory_2, 'Produk', () {
            Get.back();
            Get.offAllNamed(AppRoutes.products);
          }),
           _item(Icons.people, 'Pelanggan', () {
            Get.back();
            Get.offAllNamed(AppRoutes.customers);
          }),
          _item(Icons.inventory, 'Stok Barang', () {
            Get.back();
            Get.offAllNamed(AppRoutes.stock);
          }),
          _item(Icons.bar_chart, 'Laporan Penjualan', () {
            Get.back();
            Get.offAllNamed(AppRoutes.salesReport);
          }),
         
          const Divider(),
          _item(Icons.logout, 'Logout', () => Get.back(), color: Colors.red),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
      onTap: onTap,
    );
  }
}
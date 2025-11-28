// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;

  const CustomAppBar({
    super.key,
    this.title = 'Dashboard',
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // =====================
            // ROW ATAS: Menu - Title - Profile
            // =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
                    onPressed: onMenuPressed ??
                        () {
                          Scaffold.of(context).openDrawer();
                        },
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(AppImages.userProfile),
                  ),
                ],
              ),
            ),

            // =====================
            // SEARCH BAR DI BAWAHNYA
            // =====================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cari Produk',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}

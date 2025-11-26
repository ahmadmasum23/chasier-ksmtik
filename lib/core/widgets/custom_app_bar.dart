// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_images.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;

  const CustomAppBar({
    super.key,
    this.title = 'Dashboard',
    this.onMenuPressed, required bool showProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Bagian atas: Menu - Title - Profile
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

                  // Foto Profil
                  const CircleAvatar(
                    radius: 20,
                   backgroundImage: AssetImage(AppImages.userProfile),
                  ),
                  const SizedBox(width: 8), 
                ],
              ),
            ),

           Padding(
  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
  child: TextField(
    decoration: InputDecoration(
      hintText: 'Cari Produk',
      hintStyle: const TextStyle(
        color: Color(0xFF94A3B8), // abu-abu soft
        fontSize: 15,
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Color(0xFF94A3B8), // warna sama dengan hint
        size: 22,
      ),
      filled: true,
      fillColor: Color(0xFFF5F7FA), // background soft seperti gambar
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50), // full rounded / bulat
        borderSide: BorderSide.none,
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140); // tinggi total (appbar + search)
}
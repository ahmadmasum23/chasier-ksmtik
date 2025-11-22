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

            // Search Bar di bawahnya
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Product',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
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
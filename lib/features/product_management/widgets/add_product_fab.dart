import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';

class AddProductFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const AddProductFAB({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.makeupColor,
            borderRadius: BorderRadius.circular(12), 
          ),
          child: const Icon(Icons.add, color: Colors.black, size: 32), // Ikon hitam
        ),
      ),
    );
  }
}
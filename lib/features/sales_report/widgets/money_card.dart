import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';

class MoneyCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color? color;

  const MoneyCard({
    super.key,
    required this.title,
    required this.amount,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: AppColors.roseShade, fontSize: 15)),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
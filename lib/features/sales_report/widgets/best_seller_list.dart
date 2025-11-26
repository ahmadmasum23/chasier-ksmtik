import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';

class BestSellerList extends StatelessWidget {
  final List<Map<String, dynamic>> bestSellers = [
    {"name": "Lipstik Matte Long Lasting", "sold": 1223},
    {"name": "Serum Vitamin C", "sold": 679},
    {"name": "Setting Spray Long Lasting", "sold": 300},
  ];

  BestSellerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Produk Terlaris",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        // Card tanpa shadow, memenuhi lebar layar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // boxShadow dihapus di sini 👇
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bestSellers.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: index == bestSellers.length - 1 ? 0 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item["sold"]} Terjual",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.roseShade,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
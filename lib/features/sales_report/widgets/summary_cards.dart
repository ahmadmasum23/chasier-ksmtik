import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SmallCard(title: "Total Transaksi", value: "4 Produk")),
        const SizedBox(width: 12),
        Expanded(child: _SmallCard(title: "Total Diskon", value: "4 Produk")),
      ],
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String title;
  final String value;

  const _SmallCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,  
        mainAxisAlignment: MainAxisAlignment.center,     
        children: [
          Text(
            title,
            style: TextStyle(color: AppColors.roseShade, fontSize: 18),
          ),
          const SizedBox(height: 8), 
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
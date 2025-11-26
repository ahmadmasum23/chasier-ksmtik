import 'package:flutter/material.dart';

class PaymentMethodList extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods = [
    {"method": "Chas", "count": 209},
    {"method": "E-Wallet", "count": 190},
    {"method": "Card", "count": 56},
  ];

  PaymentMethodList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Metode Pembayaran",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        // Card putih besar yang membungkus semua metode pembayaran
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Card pink untuk setiap metode pembayaran
              ...paymentMethods.map(
                (method) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PinkMethodCard(
                    method: method["method"],
                    count: method["count"],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PinkMethodCard extends StatelessWidget {
  final String method;
  final int count;

  const _PinkMethodCard({
    required this.method,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5), // Warna pink
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            method,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
          Text(
            "$count",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
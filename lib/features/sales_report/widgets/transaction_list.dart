import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, String>> transactions = [
    {"code": "TRX-20251015-A1B1", "date": "25 Jan 2021", "amount": "Rp 89.000"},
    {"code": "TRX-20251015-A1B2", "date": "25 Jan 2021", "amount": "Rp 89.000"},
    {"code": "TRX-20251015-A1B3", "date": "25 Jan 2021", "amount": "Rp 89.000"},
    {"code": "TRX-20251015-A1B4", "date": "25 Jan 2021", "amount": "Rp 89.000"},
    {"code": "TRX-20251015-A1B5", "date": "25 Jan 2021", "amount": "Rp 89.000"},
  ];

  TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Transaksi",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        // Satu Card besar untuk semua transaksi
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: transactions.map((transaction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction["code"]!,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            transaction["date"]!,
                            style: TextStyle(color: AppColors.roseShade, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      transaction["amount"]!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
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
        ...transactions.map((transaction) => TransactionItem(
              code: transaction["code"]!,
              date: transaction["date"]!,
              amount: transaction["amount"]!,
            )),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String code;
  final String date;
  final String amount;

  const TransactionItem({
    super.key,
    required this.code,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: TextStyle(color: AppColors.roseShade, fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
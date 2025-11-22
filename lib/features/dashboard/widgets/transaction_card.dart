import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';


class RecentTransactionsCard extends StatelessWidget {
  final List<Map<String, String>> transactions;

  const RecentTransactionsCard({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              transactions[index]['id']!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              transactions[index]['date'] ?? "Tidak ada tanggal",
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.roseShade,
              ),
            ),
            trailing: Text(
              transactions[index]['amount']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}

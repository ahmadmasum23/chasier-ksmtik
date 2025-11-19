// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/ui/widgets/card.dart';
import 'package:kasir_kosmetic/ui/widgets/base_screen.dart';
import 'package:kasir_kosmetic/ui/widgets/income_card.dart';
import 'package:kasir_kosmetic/ui/widgets/monthly_sales_chart.dart';
import 'package:kasir_kosmetic/ui/widgets/recent_transactions_card.dart';
import 'package:kasir_kosmetic/ui/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(title: 'Penjualan Aktif', value: '750'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(title: 'Total Produk', value: '5.000'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            IncomeCard(title: 'Pendapatan Hari Ini', amount: 'Rp 800.000'),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: CardMingguan(),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Penjualan Bulanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            MonthlySalesChart(
              data: [
                {'month': 'Jan', 'value': 9000000, 'active': false},
                {'month': 'Feb', 'value': 7500000, 'active': false},
                {'month': 'Mar', 'value': 8200000, 'active': false},
                {'month': 'Apr', 'value': 6400000, 'active': false},
                {'month': 'May', 'value': 7000000, 'active': false},
                {'month': 'Jun', 'value': 5000000, 'active': false},
                {'month': 'Jul', 'value': 6800000, 'active': false},
                {'month': 'Aug', 'value': 1200000, 'active': false},
                {'month': 'Sep', 'value': 1800000, 'active': false},
                {'month': 'Oct', 'value': 1500000, 'active': false},
                {'month': 'Nov', 'value': 2200000, 'active': false},
                {'month': 'Dec', 'value': 2800000, 'active': true},
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Transaksi Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RecentTransactionsCard(
              transactions: [
                {
                  'id': 'TRX-2025115-A1',
                  'amount': 'Rp 119.000',
                  'date': '15 Feb 2025',
                },
                {
                  'id': 'TRX-2025115-A2',
                  'amount': 'Rp 9.000',
                  'date': '15 Feb 2025',
                },
                {
                  'id': 'TRX-2025115-C1',
                  'amount': 'Rp 29.000',
                  'date': '15 Feb 2025',
                },
                {
                  'id': 'TRX-2025115-B1',
                  'amount': 'Rp 829.000',
                  'date': '15 Feb 2025',
                },
                {
                  'id': 'TRX-2025115-E1',
                  'amount': 'Rp 12.000',
                  'date': '15 Feb 2025',
                },
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeCard(String title, String amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

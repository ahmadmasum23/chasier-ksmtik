// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/ui/widgets/card.dart';
import 'package:kasir_kosmetic/ui/widgets/base_screen.dart';

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
                Expanded(child: _buildStatCard('Penjualan Aktif', '750')),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Total Produk', '5.000')),
              ],
            ),

            const SizedBox(height: 24),

            // === PENDAPATAN ===
            _buildIncomeCard('Pendapatan Hari Ini', 'Rp 800.000'),

            const SizedBox(height: 24),

            // === CHART PENJUALAN 7 HARI TERAKHIR ===
            const Text(
              'Penjualan 7 Hari Terakhir',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMonthlyBar('Aug', 1200000),
                    _buildMonthlyBar('Sep', 1800000),
                    _buildMonthlyBar('Oct', 1500000),
                    _buildMonthlyBar('Nov', 2200000),
                    _buildMonthlyBar('Dec', 2800000),
                    _buildMonthlyBar('Jan', 9000000, isActive: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Transaksi Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ids = [
                    'TRX-2025115-A1',
                    'TRX-2025115-A2',
                    'TRX-2025115-C1',
                    'TRX-2025115-B1',
                    'TRX-2025115-E1',
                  ];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      ids[index],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Text(
                      'Rp 89.000',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
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

  Widget _buildMonthlyBar(String month, int amount, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              month,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Rp ${amount >= 1000000 ? '${(amount / 1000000).toStringAsFixed(1)} jt' : '${amount ~/ 1000} rb'}',
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

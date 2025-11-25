import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';
import 'package:kasir_kosmetic/features/sales_report/widgets/best_seller_list.dart';
import 'package:kasir_kosmetic/features/sales_report/widgets/export_pdf_button.dart';
import 'package:kasir_kosmetic/features/sales_report/widgets/money_card.dart';
import 'package:kasir_kosmetic/features/sales_report/widgets/payment_method_list.dart';
import 'package:kasir_kosmetic/features/sales_report/widgets/period_selector.dart';
import 'package:kasir_kosmetic/features/sales_report/widgets/summary_cards.dart';
import 'package:kasir_kosmetic/features/sales_report/widgets/transaction_list.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  String selectedPeriod = "Hari Ini";

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Laporan Penjualan",
      showProfile: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Export PDF Button
            const ExportPdfButton(),

            const SizedBox(height: 20),

            // Periode Dropdown
            PeriodSelector(
              selectedPeriod: selectedPeriod,
              onChanged: (val) => setState(() => selectedPeriod = val!),
            ),

            const SizedBox(height: 20),

            // Summary Cards
            const SummaryCards(),
            const SizedBox(height: 16),
            
            // Money Cards
            MoneyCard(
              title: "Total Penjualan",
              amount: "Rp 13.554.000",
            ),
            const SizedBox(height: 12),
            MoneyCard(
              title: "Total Modal",
              amount: "Rp 10.000.000",
            ),
            const SizedBox(height: 12),
            MoneyCard(
              title: "Total Laba",
              amount: "Rp 3.554.000",
            ),
            const SizedBox(height: 12),
            MoneyCard(
              title: "Total Rugi",
              amount: "Rp 554.000",
            ),

            const SizedBox(height: 30),

            // Transaksi Section
            TransactionList(),

            const SizedBox(height: 30),

            // Metode Pembayaran
            PaymentMethodList(),

            const SizedBox(height: 30),

            // Produk Terlaris
            BestSellerList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
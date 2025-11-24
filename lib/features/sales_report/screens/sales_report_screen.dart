import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';

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
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Export PDF ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Periode Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Teks Periode
                  Text(
                    "Periode",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPeriod,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF6B46C1), // ungu tua
                          size: 28,
                        ),
                        selectedItemBuilder: (context) {
                          return [
                                "Hari Ini",
                                "Minggu Ini",
                                "Bulan Ini",
                                "Tahun Ini",
                              ]
                              .map(
                                (e) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6B46C1),
                                    ),
                                  ),
                                ),
                              )
                              .toList();
                        },
                        items:
                            ["Hari Ini", "Minggu Ini", "Bulan Ini", "Tahun Ini"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) =>
                            setState(() => selectedPeriod = val!),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Summary Cards
            _summaryItem(
              "Total Transaksi",
              "4 Produk",
              "Total Diskon",
              "4 Produk",
            ),
            const SizedBox(height: 16),
            _moneyCard("Total Penjualan", "Rp 13.554.000"),
            const SizedBox(height: 12),
            _moneyCard("Total Modal", "Rp 10.000.000"),
            const SizedBox(height: 12),
            _moneyCard("Total Laba", "Rp 3.554.000"),
            const SizedBox(height: 12),
            _moneyCard("Total Rugi", "Rp 554.000"),

            const SizedBox(height: 30),

            // Transaksi Section
            Text(
              "Transaksi",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              5,
              (i) => _transactionItem(
                "TRX-20251015-A1B${i + 1}",
                "25 Jan 2021",
                "Rp 89.000",
              ),
            ),

            const SizedBox(height: 30),

            // Metode Pembayaran
            Text(
              "Metode Pembayaran",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _paymentMethod("Chas", 209, isFirst: true),
            _paymentMethod("E-Wallet", 190),
            _paymentMethod("Card", 56),

            const SizedBox(height: 30),

            // Produk Terlaris
            Text(
              "Produk Terlaris",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _bestSellerItem("Lipstik Matte Long Lasting", 1223),
            _bestSellerItem("Serum Vitamin C", 679),
            _bestSellerItem("Setting Spray Long Lasting", 300),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(
    String leftTitle,
    String leftValue,
    String rightTitle,
    String rightValue,
  ) {
    return Row(
      children: [
        Expanded(child: _smallCard(leftTitle, leftValue)),
        const SizedBox(width: 12),
        Expanded(child: _smallCard(rightTitle, rightValue)),
      ],
    );
  }

  Widget _smallCard(String title, String value) {
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


  Widget _moneyCard(String title, String amount, {Color? color}) {
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
          Text(title, style: TextStyle(color:AppColors.roseShade, fontSize: 15)),
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

  Widget _transactionItem(String code, String date, String amount) {
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
                Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
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

  Widget _paymentMethod(String method, int count, {bool isFirst = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: isFirst ? 0 : 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isFirst ? Colors.pink[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            method,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Text(
            "$count",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _bestSellerItem(String name, int sold) {
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
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Text("$sold Terjual", style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}

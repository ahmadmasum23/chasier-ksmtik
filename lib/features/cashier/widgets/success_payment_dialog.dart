import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';

class SuccessPaymentDialog extends StatelessWidget {
  final int totalAmount;
  final String paymentMethod;
  final String customerName;
  final Map<int, int> cart;
  final List<ProductModel> products;
  final int? changeAmount;

  const SuccessPaymentDialog({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
    required this.customerName,
    required this.cart,
    required this.products,
    this.changeAmount,
  });

  String _generateTransactionId() {
    final now = DateTime.now();
    final random = now.millisecondsSinceEpoch % 1000;
    return "TRX-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${random}A1B";
  }

  String _formatRupiah(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final transactionId = _generateTransactionId();
    final now = DateTime.now();

    String dateFormat;
    try {
      dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(now);
    } catch (e) {
      dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id').format(now);
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.softPink,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),

            const Text(
              "Pembayaran Berhasil",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.softPink.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentMethod,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _formatRupiah(totalAmount),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow("Nomor Pesanan", transactionId),
                  _buildInfoRow("Tanggal Pembayaran", dateFormat),
                  _buildInfoRow(
                    "Nama Pembeli",
                    customerName.isEmpty ? "Walk-in Customer" : customerName,
                  ),
                  if (paymentMethod == "Cash" && changeAmount != null) ...[
                    _buildInfoRow("Kembalian", _formatRupiah(changeAmount!)),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // ✅ Buka preview struk mini
                      _showReceiptPreview(context, transactionId, dateFormat);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: AppColors.softPink),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Lihat Struk",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Tutup dialog sukses
                      Get.back(); // Tutup modal checkout
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Selesai",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptPreview(
    BuildContext context,
    String transactionId,
    String dateFormat,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true, // bisa ditutup dengan klik di luar
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Preview Struk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),

                // ✅ Struk dalam container berbentuk "struk"
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 360, // maks lebar seperti struk sungguhan
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'KASIR KOSMETIK',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Jl. SMK Brantas Karangkates',
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          'Malang, Jawa Timur',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1),
                        Text(
                          'No: $transactionId',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Tgl: $dateFormat',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Pelanggan: ${customerName.isEmpty ? "Umum" : customerName}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1),
                        const SizedBox(height: 6),
                        const Text(
                          'Daftar Barang:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),

                        ...cart.entries.map((entry) {
                          final product = products.firstWhere(
                            (p) => p.id == entry.key,
                            orElse: () => ProductModel(
                              id: 0,
                              nama: 'Produk Tidak Ditemukan',
                              hargaBeli: 0,
                              hargaJual: 0,
                              stok: 0,
                              dibuatPada: DateTime.now(),
                              kategori: '',
                            ),
                          );
                          final totalHarga =
                              product.hargaJual.toInt() * entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${product.nama} x${entry.value}',
                                    style: const TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  _formatRupiah(totalHarga),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 12),
                        const Divider(thickness: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatRupiah(totalAmount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (paymentMethod == "Cash" && changeAmount != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Text(
                                  'Kembalian:',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const Spacer(),
                                Text(
                                  _formatRupiah(changeAmount!),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 12),
                        const Divider(thickness: 1),
                        const SizedBox(height: 8),
                        const Text(
                          'Terima kasih telah berbelanja!',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ✅ Tombol "Jadikan PDF"
                SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context); // Tutup popup
                      await _generateAndPrintReceipt(transactionId, dateFormat);
                    },
                    icon: const Icon(Icons.picture_as_pdf, size: 20),
                    label: const Text(
                      "Jadikan PDF",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _generateAndPrintReceipt(String transactionId, String dateFormat) async {
  final pdf = pw.Document();

  final a5PageFormat = PdfPageFormat.a5.copyWith(
    marginLeft: 0,
    marginRight: 0,
    marginTop: 0,
    marginBottom: 0,
  );

  // Hitung nominal yang dibayar jika Cash
  int? cashPaidAmount;
  if (paymentMethod == "Cash" && changeAmount != null) {
    cashPaidAmount = totalAmount + changeAmount!;
  }

  pdf.addPage(
    pw.Page(
      pageFormat: a5PageFormat,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(child: pw.Text('KASIR KOSMETIK', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 2),
              pw.Center(child: pw.Text('Jl. SMK Brantas Karangkates', style: pw.TextStyle(fontSize: 11))),
              pw.Center(child: pw.Text('Malang, Jawa Timur', style: pw.TextStyle(fontSize: 11))),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 8),

              // Info Transaksi
              pw.Text('No Transaksi: $transactionId', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Tanggal: $dateFormat', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Pelanggan: ${customerName.isEmpty ? "Umum" : customerName}', style: pw.TextStyle(fontSize: 11)),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 8),

              // Daftar Barang
              pw.Text('Barang yang Dibeli:', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),

              ...cart.entries.map((entry) {
                final product = products.firstWhere(
                  (p) => p.id == entry.key,
                  orElse: () => ProductModel(
                    id: 0,
                    nama: 'Produk Tidak Ditemukan',
                    hargaBeli: 0,
                    hargaJual: 0,
                    stok: 0,
                    dibuatPada: DateTime.now(),
                    kategori: '',
                  ),
                );
                final totalHarga = product.hargaJual.toInt() * entry.value;
                return pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text('${product.nama} x${entry.value}', style: pw.TextStyle(fontSize: 12)),
                    ),
                    pw.Text(_formatRupiah(totalHarga), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ],
                );
              }).toList(),

              pw.SizedBox(height: 10),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 8),

              // Rincian Pembayaran
              pw.Text('Rincian Pembayaran:', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),

              pw.Row(
                children: [
                  pw.Text('Total Belanja', style: pw.TextStyle(fontSize: 12)),
                  pw.Spacer(),
                  pw.Text(_formatRupiah(totalAmount), style: pw.TextStyle(fontSize: 12)),
                ],
              ),

              // Metode Pembayaran
              pw.Row(
                children: [
                  pw.Text('Metode', style: pw.TextStyle(fontSize: 12)),
                  pw.Spacer(),
                  pw.Text(paymentMethod, style: pw.TextStyle(fontSize: 12)),
                ],
              ),

              // Jika Cash: tampilkan Dibayar & Kembalian
              if (paymentMethod == "Cash") ...[
                if (cashPaidAmount != null)
                  pw.Row(
                    children: [
                      pw.Text('Dibayar', style: pw.TextStyle(fontSize: 12)),
                      pw.Spacer(),
                      pw.Text(_formatRupiah(cashPaidAmount), style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                if (changeAmount != null && changeAmount! > 0)
                  pw.Row(
                    children: [
                      pw.Text('Kembalian', style: pw.TextStyle(fontSize: 12)),
                      pw.Spacer(),
                      pw.Text(_formatRupiah(changeAmount!), style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
              ],

              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 16),

              // Footer
              pw.Center(child: pw.Text('Terima kasih telah berbelanja!', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal))),

              pw.SizedBox(height: 20),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

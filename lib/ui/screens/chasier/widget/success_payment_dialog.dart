// lib/ui/widgets/success_payment_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_kosmetic/ui/constants/colors.dart';

class SuccessPaymentDialog extends StatelessWidget {
  final int totalAmount;
  final String paymentMethod;
  final String customerName;

  const SuccessPaymentDialog({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
    required this.customerName,
  });

  // Generate nomor transaksi unik
  String _generateTransactionId() {
    final now = DateTime.now();
    final random = now.millisecondsSinceEpoch % 1000;
    return "TRX-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${random}A1B";
  }

  // Format rupiah pakai intl (pasti aman)
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

    // Pastikan locale sudah siap — fallback ke 'id' kalau 'id_ID' gagal
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
            // Centang di lingkaran pink
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

            // Card Info Pembayaran (sesuai gambar)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.softPink.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metode Pembayaran
                  Text(
                    paymentMethod,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total
                  Text(
                    _formatRupiah(totalAmount),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Detail Transaksi
                  _buildInfoRow("Nomor Pesanan", transactionId),
                  _buildInfoRow("Tanggal Pembayaran", dateFormat),
                  _buildInfoRow("Nama Pembeli", customerName.isEmpty ? "Walk-in Customer" : customerName),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Cetak Struk & Selesai
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context)..pop()..pop(); // tutup dialog + modal checkout
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
                      "Cetak Struk",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)..pop()..pop(); // sama
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
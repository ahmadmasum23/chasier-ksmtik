// lib/features/cashier/widgets/cart_summary_card.dart
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:collection/collection.dart';

class CartSummaryCard extends StatelessWidget {
  final Map<int, int> cart;
  final List<ProductModel> products;
  final VoidCallback onCheckoutPressed;

  const CartSummaryCard({
    super.key,
    required this.cart,
    required this.products,
    required this.onCheckoutPressed,
  });

  int get totalPrice {
    int total = 0;
    cart.forEach((id, qty) {
      final product = products.where((p) => p.id == id).firstOrNull;
      if (product != null) {
        total += product.hargaJual.toInt() * qty;
      }
    });
    return total;
  }

  static String formatRupiah(int amount) {
    if (amount == 0) return "Rp 0";
    return "Rp ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}";
  }

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // radius lebih besar agar lembut
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // IKON KERANJANG DALAM Kotak PINK
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.softPink.withOpacity(0.3), // pink muda
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shopping_cart,
              color: AppColors.softPink,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          // TEKS: "Keranjang Belanja" + Total Harga
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Keranjang Belanja",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.roseShade,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatRupiah(totalPrice),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // TOMBOL CHECKOUT
          ElevatedButton(
            onPressed: onCheckoutPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.softPink.withOpacity(0.3),
              foregroundColor: AppColors.softPink,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Check Out",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
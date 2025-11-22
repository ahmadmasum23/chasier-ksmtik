// lib/ui/screens/chasier/widget/cart_summary_card.dart
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';


class CartSummaryCard extends StatelessWidget {
  final Map<int, int> cart;                    
  final List<Map<String, dynamic>> products;   
  final VoidCallback onCheckoutPressed;       

  const CartSummaryCard({
    super.key,
    required this.cart,
    required this.products,
    required this.onCheckoutPressed,
  });

  // Hitung total harga
  int get _totalPrice {
    int total = 0;
    cart.forEach((productId, qty) {
      final product = products.firstWhere(
        (p) => p["id"] == productId,
        orElse: () => <String, dynamic>{},
      );
      final price = product["price"] as int? ?? 0;
      total += price * qty;
    });
    return total;
  }

  // Format rupiah sederhana (dengan titik ribuan)
  String _formatRupiah(int amount) {
    final formatted = amount
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = cart.isNotEmpty;
    if (!hasItems) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon keranjang
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.softPink,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          // Info keranjang
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Keranjang Belanja",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.roseShade,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatRupiah(_totalPrice),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.roseShade,
                  ),
                ),
              ],
            ),
          ),

          // Tombol Checkout
          ElevatedButton(
            onPressed: hasItems ? onCheckoutPressed : null, 
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.softPink,
              foregroundColor: Colors.white,
              elevation: 0,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
            child: const Text(
              "Check Out",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
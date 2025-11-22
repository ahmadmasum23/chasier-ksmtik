// File: lib/ui/screens/chasier/cashier_screen.dart

import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';
import 'package:kasir_kosmetic/features/cashier/widgets/cart_summary_card.dart';
import 'package:kasir_kosmetic/features/cashier/widgets/checkout_screen.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  final List<Map<String, dynamic>> products = const [
    {
      "id": 1,
      "brand": "Lipstik Matte Long Lasting ",
      "category": "Makeup",
      "price": 89000,
      "stock": 45,
      "image": "assets/images/mackup.png",
    },
    {
      "id": 2,
      "brand": "Serum Vitamin C",
      "category": "Makeup",
      "price": 99000,
      "stock": 45,
      "image": "assets/images/liftik.png",
    },
    {
      "id": 3,
      "brand": "Setting Spray Long Lasting ",
      "category": "Skincare",
      "price": 69000,
      "stock": 45,
      "image": "assets/images/skincare.png",
    },
  ];

  final Map<int, int> _cart = {};

  String formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (m) => '${m[1]}.',
    );
    return "Rp $formatted";
  }

  void _addToCart(int productId) {
    setState(() {
      _cart[productId] = (_cart[productId] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = _cart.isNotEmpty;

    return BaseScreen(
      title: "Cashier",
      showProfile: true,
      body: Column(
        children: [
          CartSummaryCard(
            cart: _cart,
            products: products,
            onCheckoutPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => CheckoutModal(
                  cart: Map.from(_cart),
                  products: products,
                  onPaymentSuccess: () {
                    setState(() => _cart.clear());
                  },
                ),
              );
            },
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(24, hasItems ? 8 : 24, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Produk Saya",
                  style: TextStyle(
                    color: AppColors.teks,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        color: AppColors.teks,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List produk
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              // sebelumnya itemCount: products.length + 20 -> akan membuat pengulangan tak terduga
              // jika memang dimaksud untuk demo, ubah; di sini saya kembalikan ke products.length agar UI konsisten
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];

                return GestureDetector(
                  onTap: () => _addToCart(item["id"] as int),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item["image"],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey[300]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["brand"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["category"],
                                style: TextStyle(
                                  color: AppColors.roseShade,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Stok: ${item["stock"]}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.roseShade,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatRupiah(item["price"] as int),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.softPink,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

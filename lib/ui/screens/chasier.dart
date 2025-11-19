import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/ui/constants/colors.dart';
import 'package:kasir_kosmetic/ui/widgets/base_screen.dart';
import 'package:kasir_kosmetic/ui/widgets/checkout_screen.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  // Data produk dummy
  final List<Map<String, dynamic>> products = const [
    {
      "id": 1,
      "brand": "Apple Store",
      "category": "Makeup",
      "price": 89000,
      "stock": 45,
      "image": "assets/images/mackup.png",
    },
    {
      "id": 2,
      "brand": "Samsung Mobile",
      "category": "Makeup",
      "price": 99000,
      "stock": 45,
      "image": "assets/images/liftik.png",
    },
    {
      "id": 3,
      "brand": "Tesla Motors",
      "category": "Skincare",
      "price": 69000,
      "stock": 45,
      "image": "assets/images/skincare.png",
    },
  ];

  // Keranjang
  final Map<int, int> _cart = {};

  int get totalPrice {
    int total = 0;
    _cart.forEach((id, qty) {
      final product = products.firstWhere((p) => p["id"] == id);
      total += (product["price"] as int) * qty;
    });
    return total;
  }

  String formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
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
    final bool hasItems = _cart.isNotEmpty;

    return BaseScreen(
      title: "Cashier",
      showProfile: true,
      body: Column(
        children: [
          // === Cart Bar (muncul di atas, tepat di bawah CustomAppBar) ===
          if (hasItems)
            Container(
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Keranja Belanja",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.roseShade,
                          ),
                        ),
                        Text(
                          formatRupiah(totalPrice),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.roseShade,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_cart.isEmpty) return;

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // penting biar modal bisa tinggi
                        backgroundColor: Colors.transparent,
                        builder: (_) => CheckoutModal(
                          cart: Map.from(_cart), // kirim copy cart
                          products: products,
                          onPaymentSuccess: () {
                            setState(
                              () => _cart.clear(),
                            ); // kosongkan keranjang setelah bayar
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                    child: const Text(
                      "Check Out",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

          // === Header My Product ===
          Padding(
            padding: EdgeInsets.fromLTRB(24, hasItems ? 8 : 24, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Product",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // === List Produk ===
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: products.length + 20,
              itemBuilder: (context, index) {
                final i = index % products.length;
                final item = products[i];

                return GestureDetector(
                  onTap: () => _addToCart(item["id"]),
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
                                  color: Colors.grey[600],
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
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatRupiah(item["price"]),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.pink,
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

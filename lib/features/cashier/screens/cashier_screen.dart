// lib/ui/screens/cashier/cashier_screen.dart
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';
import 'package:kasir_kosmetic/features/cashier/widgets/cart_summary_card.dart';
import 'package:kasir_kosmetic/features/cashier/widgets/checkout_screen.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/data/services/product_service.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  final ProductService _productService = ProductService();
  final Map<int, int> _cart = {};
  String _searchQuery = '';
  String _selectedCategory = 'All'; // 'All', 'Skincare', 'Makeup'

  void _addToCart(int productId) {
    setState(() {
      _cart[productId] = (_cart[productId] ?? 0) + 1;
    });
  }

  String formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return "Rp $formatted";
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    if (_searchQuery.isNotEmpty) {
      products = products
          .where(
            (p) => p.nama.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (_selectedCategory != 'All') {
      products = products
          .where((p) => p.kategori == _selectedCategory)
          .toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Cashier",
      showProfile: true,
      body: FutureBuilder<List<ProductModel>>(
        future: _productService.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Produk belum tersedia"));
          }

          final products = snapshot.data!;
          final filteredProducts = _filterProducts(products);

          return Column(
            children: [
              // CART SUMMARY
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
              const SizedBox(height: 16),

              // HEADER: "Produk Saya" + FILTER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        items: [
                          DropdownMenuItem(
                            value: 'All',
                            child: const Text('See All'),
                          ),
                          DropdownMenuItem(
                            value: 'Skincare',
                            child: const Text('Skincare'),
                          ),
                          DropdownMenuItem(
                            value: 'Makeup',
                            child: const Text('Makeup'),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _selectedCategory = v!;
                          });
                        },
                        underline: Container(), // hilangkan garis bawah
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        dropdownColor: Colors.white,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                        ),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // untuk popup dropdown juga rounded
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // PRODUCT LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return GestureDetector(
                      onTap: () => _addToCart(product.id),
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
                              child: Image.network(
                                product.urlGambar ?? '',
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
                                    product.nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    product.kategori ?? '-',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.roseShade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Stok: ${product.stok}"),
                                 IconButton(
                                  onPressed: () => _addToCart(product.id),
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: AppColors.softPink,
                                    size: 24,
                                  ),
                                  splashRadius: 20,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formatRupiah(product.hargaJual.toInt()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
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
          );
        },
      ),
    );
  }
}

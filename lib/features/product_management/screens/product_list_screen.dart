import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/features/product_management/controller/product_controller.dart';
import 'package:kasir_kosmetic/features/product_management/widgets/product_list.dart';
import 'package:kasir_kosmetic/features/product_management/widgets/add_product_fab.dart';
import 'package:kasir_kosmetic/features/product_management/widgets/product_form_dialog.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final ProductController _controller = ProductController();
  bool _isSeeAllExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller.loadProducts();
  }

  void _showAddEditDialog([ProductModel? product]) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) =>
          ProductFormDialog(controller: _controller, product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Manajemen Produk",
      showProfile: true,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My Product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(
                        () => _isSeeAllExpanded = !_isSeeAllExpanded,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Text(
                                _controller.selectedCategory.value.isEmpty
                                    ? "See All"
                                    : _controller.selectedCategory.value,
                                style: TextStyle(
                                  color: const Color(
                                    0xFF343C6A,
                                  ), // Warna teks sesuai permintaan
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isSeeAllExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: const Color(0xFF343C6A),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Product List
              Expanded(
                child: ProductList(
                  controller: _controller,
                  onEditProduct: _showAddEditDialog,
                ),
              ),
            ],
          ),

          if (_isSeeAllExpanded)
            Positioned(
              top: 50,
              right: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8),
                  // border: Border.all(color: Colors.grey.shade300), // opsional
                ),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // ✅ Pastikan ini start
                    children: [
                      _buildFilterOption("See All", null),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),
                      _buildFilterOption("Makeup", "Makeup"),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),
                      _buildFilterOption("Skincare", "Skincare"),
                    ],
                  ),
                ),
              ),
            ),

          // Add Product FAB
          AddProductFAB(onPressed: () => _showAddEditDialog()),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, String? value) {
    final bool isSelected =
        (value == null && _controller.selectedCategory.value.isEmpty) ||
        (value != null && _controller.selectedCategory.value == value);

    return GestureDetector(
      onTap: () {
        _controller.filterByCategory(value);
        setState(() => _isSeeAllExpanded = false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.pink : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

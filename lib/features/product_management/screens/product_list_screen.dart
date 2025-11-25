import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/features/product_management/controller/product_controller.dart';
import 'package:kasir_kosmetic/features/product_management/widgets/category_filter.dart';
import 'package:kasir_kosmetic/features/product_management/widgets/product_list.dart';
import 'package:kasir_kosmetic/features/product_management/widgets/add_product_fab.dart';
import 'package:kasir_kosmetic/features/product_management/widgets/product_form_dialog.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ProductFormDialog(
        controller: _controller,
        product: product,
      ),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isSeeAllExpanded = !_isSeeAllExpanded),
                      child: Row(
                        children: [
                          Obx(() => Text(
                            _controller.selectedCategory.value.isEmpty ? "See All" : _controller.selectedCategory.value,
                            style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.w600)
                          )),
                          const SizedBox(width: 4),
                          Icon(
                            _isSeeAllExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
                            color: Colors.pink
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Category Filter
              CategoryFilter(
                isExpanded: _isSeeAllExpanded,
                selectedCategory: _controller.selectedCategory.value,
                onCategorySelected: (category) {
                  _controller.filterByCategory(category);
                  setState(() => _isSeeAllExpanded = false);
                },
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

          // Add Product FAB
          AddProductFAB(onPressed: () => _showAddEditDialog()),
        ],
      ),
    );
  }
}
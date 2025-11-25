import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/features/product_management/controller/product_controller.dart';
import 'package:kasir_kosmetic/features/product_management/widgets/product_item.dart';

class ProductList extends StatelessWidget {
  final ProductController controller;
  final Function(ProductModel) onEditProduct;

  const ProductList({
    super.key,
    required this.controller,
    required this.onEditProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.pink),
        );
      }

      if (controller.filteredProducts.isEmpty) {
        return const Center(
          child: Text(
            "Belum ada produk",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = controller.filteredProducts[index];
          return ProductItem(
            product: product,
            controller: controller,
            onEdit: onEditProduct,
          );
        },
      );
    });
  }
}
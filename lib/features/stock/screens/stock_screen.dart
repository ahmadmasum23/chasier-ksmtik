// lib/ui/screens/stock/stock_product_screen.dart
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/data/services/product_service.dart';

class StockProductScreen extends StatefulWidget {
  const StockProductScreen({super.key});

  @override
  State<StockProductScreen> createState() => _StockProductScreenState();
}

class _StockProductScreenState extends State<StockProductScreen> {
  // 0 = All, 1 = Stok Habis, 2 = Stok Menipis
  int _selectedTab = 0;

  final ProductService _productService = ProductService();

  // Helper: ambil minStock dari product (jika ada di model) atau default ke 10
  int _getMinStock(ProductModel product) {
    // Jika kamu tambahkan field `stokMinimum` di ProductModel, ganti ini:
    // return product.stokMinimum ?? 10;
    return 10; // default sementara
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    switch (_selectedTab) {
      case 1: // Stok Habis
        return products.where((p) => p.stok == 0).toList();
      case 2: // Stok Menipis
        return products.where((p) => p.stok > 0 && p.stok <= _getMinStock(p)).toList();
      default: // All
        return products;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Stok Barang",
      showProfile: false,
      body: FutureBuilder<List<ProductModel>>(
        future: _productService.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Gagal memuat data: ${snapshot.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data ?? [];
          final filteredProducts = _filterProducts(products);

          return Column(
            children: [
              const SizedBox(height: 16),

              // 3 CARD FILTER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildTabCard(
                      title: "All Product",
                      count: products.length,
                      index: 0,
                    ),
                    const SizedBox(width: 12),
                    _buildTabCard(
                      title: "Stok Habis",
                      count: products.where((p) => p.stok == 0).length,
                      index: 1,
                    ),
                    const SizedBox(width: 12),
                    _buildTabCard(
                      title: "Stok Menipis",
                      count: products.where((p) => p.stok > 0 && p.stok <= _getMinStock(p)).length,
                      index: 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // LIST PRODUK
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          "Tidak ada produk",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) => _buildProductItem(filteredProducts[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabCard({
    required String title,
    required int count,
    required int index,
  }) {
    final bool isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.roseShade : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$count Produk",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.roseShade : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(ProductModel product) {
    final minStock = _getMinStock(product);
    final bool isLow = product.stok > 0 && product.stok <= minStock;
    final bool isOutOfStock = product.stok == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.urlGambar ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nama,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.kategori ?? '-',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Stok : ${product.stok}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isOutOfStock || isLow ? Colors.red : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
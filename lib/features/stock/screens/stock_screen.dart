import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';

class StockProductScreen extends StatefulWidget {
  const StockProductScreen({super.key});

  @override
  State<StockProductScreen> createState() => _StockProductScreenState();
}

class _StockProductScreenState extends State<StockProductScreen> {
  // 0 = All, 1 = Stok Habis, 2 = Stok Menipis
  int _selectedTab = 0;

  final List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "name": "Lipstik Matte Long Lasting",
      "category": "Makeup",
      "price": 89000,
      "stock": 45,
      "minStock": 10,
      "image": "assets/images/mackup.png",
    },
    {
      "id": 2,
      "name": "Serum Vitamin C",
      "category": "Skincare",
      "price": 125000,
      "stock": 8,
      "minStock": 15,
      "image": "assets/images/skincare.png",
    },
    {
      "id": 3,
      "name": "Setting Spray Long Lasting",
      "category": "Makeup",
      "price": 110000,
      "stock": 0,
      "minStock": 20,
      "image": "assets/images/liftik.png",
    },
    {
      "id": 4,
      "name": "Lipstik Matte Long Lasting",
      "category": "Makeup",
      "price": 89000,
      "stock": 3,
      "minStock": 10,
      "image": "assets/images/mackup.png",
    },
  ];

  List<Map<String, dynamic>> get currentList {
    switch (_selectedTab) {
      case 1:
        return products.where((p) => p["stock"] == 0).toList();
      case 2:
        return products.where((p) => p["stock"] <= p["minStock"] && p["stock"] > 0).toList();
      default:
        return products;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Stok Barang",
      showProfile: false,
      body: Column(
        children: [
          const SizedBox(height: 16),

          // 3 CARD TERPISAH (bukan TabBar lagi)
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
                  count: products.where((p) => p["stock"] == 0).length,
                  index: 1,
                ),
                const SizedBox(width: 12),
                _buildTabCard(
                  title: "Stok Menipis",
                  count: products.where((p) => p["stock"] <= p["minStock"] && p["stock"] > 0).length,
                  index: 2,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Konten List Produk
          Expanded(
            child: currentList.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada produk",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: currentList.length,
                    itemBuilder: (context, index) => _buildProductItem(currentList[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // CARD TERPISAH untuk setiap tab
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

  Widget _buildProductItem(Map<String, dynamic> product) {
    final bool isLow = product["stock"] <= product["minStock"];
    final bool isOutOfStock = product["stock"] == 0;

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
            child: Image.asset(
              product["image"],
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
                  product["name"],
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product["category"],
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Stok : ${product["stock"]}",
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
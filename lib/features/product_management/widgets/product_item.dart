import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/features/product_management/controller/product_controller.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final ProductController controller;
  final Function(ProductModel) onEdit;

  const ProductItem({
    super.key,
    required this.product,
    required this.controller,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // sedikit lebih besar
      padding: const EdgeInsets.all(16), // dari 12 jadi 16
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // dari 12 jadi 16
      ),
      child: Row(
        children: [
          // Gambar Produk (diperbesar)
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // dari 8 jadi 10
            child: product.urlGambar != null
                ? Image.network(
                    product.urlGambar!,
                    width: 60, // dari 50 jadi 60
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                  )
                : _buildPlaceholderImage(),
          ),
          const SizedBox(width: 16), // dari 12 jadi 16

          // Informasi Produk (Nama & Kategori)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15, // dari 14 jadi 15
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.kategori ?? "-",
                  style: TextStyle(
                    color: Colors.pink[300],
                    fontSize: 13, // dari 12 jadi 13
                  ),
                ),
              ],
            ),
          ),

          // Harga + Ikon Edit & Delete (dalam satu kolom)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Harga (di atas)
              Text(
                "Rp ${controller.formatRupiah(product.hargaJual.toInt())}",
                style: TextStyle(
                  color: Colors.pink[300],
                  fontWeight: FontWeight.w600,
                  fontSize: 15, // dari 14 jadi 15
                ),
              ),
              const SizedBox(height: 8), // dari 4 jadi 8
              // Ikon Edit & Delete (sejajar horizontal di bawah harga)
              Row(
                children: [
                  InkWell(
                    onTap: () => onEdit(product),
                    child: const Icon(Icons.edit, color: Colors.grey, size: 18), // dari 16 jadi 18
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _showDeleteDialog(context, product.id),
                    child: const Icon(Icons.delete, color: Colors.grey, size: 18), // dari 16 jadi 18
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[200],
      child: const Icon(Icons.image, color: Colors.grey, size: 22),
    );
  }

  void _showDeleteDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: const Text("Produk ini akan dihapus permanen dari database."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop(true);
              controller.deleteProduct(productId);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
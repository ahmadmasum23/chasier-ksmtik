// lib/ui/screens/product_management_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "name": "Lipstik Matte Long Lasting Makeup",
      "category": "Makeup",
      "price": 89000,
      "purchasePrice": 65000, // harga beli
      "stock": 45,
      "image": "assets/images/liftik.png",
    },
    {
      "id": 2,
      "name": "Serum Vitamin C Skincare",
      "category": "Skincare",
      "price": 99000,
      "purchasePrice": 75000,
      "stock": 46,
      "image": "assets/images/skincare.png",
    },
    {
      "id": 3,
      "name": "Setting Spray Long Lasting Makeup",
      "category": "Makeup",
      "price": 99000,
      "purchasePrice": 72000,
      "stock": 45,
      "image": "assets/images/mackup.png",
    },
  ];

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _purchasePriceCtrl = TextEditingController();
  final TextEditingController _stockCtrl = TextEditingController();

  String? _selectedCategory;
  int? _editIndex;
  bool _isSeeAllExpanded = false;

  // Daftar kategori tetap
  final List<String> categories = ["Makeup", "Skincare"];

  // Hitung stok per kategori secara real-time
  Map<String, int> get categoryStock {
    final Map<String, int> stockMap = {};
    for (var p in products) {
      final String category = p["category"] as String;
      final int stock = (p["stock"] is int)
          ? p["stock"] as int
          : (p["stock"] as num).toInt();
      stockMap[category] = (stockMap[category] ?? 0) + stock;
    }
    return stockMap;
  }

  // Produk yang difilter
  List<Map<String, dynamic>> get filteredProducts {
    if (_selectedCategory == null) return products;
    return products.where((p) => p["category"] == _selectedCategory).toList();
  }

  String formatRupiah(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  void _saveProduct() {
    if (_nameCtrl.text.isEmpty ||
        _priceCtrl.text.isEmpty ||
        _purchasePriceCtrl.text.isEmpty ||
        _stockCtrl.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi!")),
      );
      return;
    }

    final newProduct = {
      "id": _editIndex == null
          ? DateTime.now().millisecondsSinceEpoch
          : products[_editIndex!]["id"],
      "name": _nameCtrl.text,
      "category": _selectedCategory!,
      "price": int.parse(_priceCtrl.text.replaceAll(".", "")),
      "purchasePrice": int.parse(_purchasePriceCtrl.text.replaceAll(".", "")),
      "stock": int.parse(_stockCtrl.text),
      "image": "assets/images/default_product.png", // placeholder
    };

    setState(() {
      if (_editIndex == null) {
        products.add(newProduct);
      } else {
        products[_editIndex!] = newProduct;
        _editIndex = null;
      }
    });

    _nameCtrl.clear();
    _priceCtrl.clear();
    _purchasePriceCtrl.clear();
    _stockCtrl.clear();
    _selectedCategory = null;
    Get.back();
  }

  void _editProduct(int index) {
    final p = products[index];
    _nameCtrl.text = p["name"];
    _selectedCategory = p["category"];
    _priceCtrl.text = p["price"].toString();
    _purchasePriceCtrl.text = p["purchasePrice"].toString();
    _stockCtrl.text = p["stock"].toString();
    _editIndex = index;
    _showAddEditDialog();
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: const Text("Produk ini akan dihapus permanen."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => products.removeAt(index));
              Get.back();
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _editIndex == null ? "Tambah Produk Baru" : "Edit Produk",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Nama Produk
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "Nama Produk",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Kategori
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
              ),
              items: [
                ...categories.map(
                  (cat) => DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 12),

            // Harga Jual
            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Harga Jual (tanpa titik)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Harga Beli
            TextField(
              controller: _purchasePriceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Harga Beli (tanpa titik)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Stok
            TextField(
              controller: _stockCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Stok",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Upload Gambar (placeholder)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.image, size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  const Text(
                    "Upload Gambar",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveProduct,
                child: Text(
                  _editIndex == null ? "Tambah Produk" : "Update Produk",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
        // Konten utama
        Column(
          children: [
            const SizedBox(height: 10),

            // HEADER + SEE ALL FILTER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
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
                        onTap: () {
                          setState(() {
                            _isSeeAllExpanded = !_isSeeAllExpanded;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              _selectedCategory ?? "See All",
                              style: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isSeeAllExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.pink,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Dropdown Filter Kategori
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstChild: const SizedBox.shrink(),
                    secondChild: Container(
                      margin: const EdgeInsets.only(top: 16),
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
                      child: Column(
                        children: [
                          _buildFilterOption("See All", null),
                          const Divider(height: 28),
                          ...categories.map(
                            (cat) => Column(
                              children: [
                                _buildFilterOption(cat, cat),
                                if (cat != categories.last)
                                  const Divider(height: 28),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    crossFadeState: _isSeeAllExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // LIST PRODUK
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final p = filteredProducts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              p["image"],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p["category"],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      "Rp ${formatRupiah(p["price"])}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Stok: ${p["stock"]}",
                                      style: const TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            children: [
                              InkWell(
                                onTap: () => _editProduct(products.indexOf(p)),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _deleteProduct(products.indexOf(p)),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                  size: 20,
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

        // Floating Action Button Manual (kanan bawah)
        Positioned(
          bottom: 24,
          right: 24,
          child: GestureDetector(
            onTap: _showAddEditDialog,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // Widget untuk setiap opsi di dropdown filter
  Widget _buildFilterOption(String title, String? categoryValue) {
    final isSelected = _selectedCategory == categoryValue;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = categoryValue;
          _isSeeAllExpanded = false; // tutup otomatis setelah pilih
        });
      },
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: Colors.pink,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.pink : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
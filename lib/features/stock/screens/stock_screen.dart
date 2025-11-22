import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';

class StockProductScreen extends StatefulWidget {
  const StockProductScreen({super.key});

  @override
  State<StockProductScreen> createState() => _StockProductScreenState();
}

class _StockProductScreenState extends State<StockProductScreen> {
  // Sample data - in a real app, this would come from a database or API
  List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "name": "Lipstik Matte Long Lasting Makeup",
      "category": "Makeup",
      "stock": 45,
      "minStock": 10,
      "unit": "pcs",
      "lastUpdated": "2025-11-15",
    },
    {
      "id": 2,
      "name": "Serum Vitamin C Skincare",
      "category": "Skincare",
      "stock": 46,
      "minStock": 15,
      "unit": "pcs",
      "lastUpdated": "2025-11-16",
    },
    {
      "id": 3,
      "name": "Setting Spray Long Lasting Makeup",
      "category": "Makeup",
      "stock": 45,
      "minStock": 20,
      "unit": "pcs",
      "lastUpdated": "2025-11-17",
    },
    {
      "id": 4,
      "name": "Moisturizer Cream",
      "category": "Skincare",
      "stock": 5,
      "minStock": 10,
      "unit": "pcs",
      "lastUpdated": "2025-11-17",
    },
    {
      "id": 5,
      "name": "Foundation Liquid",
      "category": "Makeup",
      "stock": 12,
      "minStock": 15,
      "unit": "pcs",
      "lastUpdated": "2025-11-16",
    },
  ];

  String? _selectedCategory;
  bool _showLowStockOnly = false;

  // Categories list
  final List<String> categories = ["All", "Makeup", "Skincare"];

  // Filtered products
  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> result = List.from(products);
    
    // Filter by category
    if (_selectedCategory != null && _selectedCategory != "All") {
      result = result.where((p) => p["category"] == _selectedCategory).toList();
    }
    
    // Filter by low stock
    if (_showLowStockOnly) {
      result = result.where((p) => p["stock"] <= p["minStock"]).toList();
    }
    
    return result;
  }

  // Format number with thousand separator
  String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  // Update stock
  void _updateStock(int productId, int newStock) {
    setState(() {
      final index = products.indexWhere((p) => p["id"] == productId);
      if (index != -1) {
        products[index]["stock"] = newStock;
        products[index]["lastUpdated"] = DateTime.now().toString().split(' ')[0];
      }
    });
  }

  // Show update stock dialog
  void _showUpdateStockDialog(Map<String, dynamic> product) {
    final TextEditingController stockController = TextEditingController(
      text: product["stock"].toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Update Stock"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Product: ${product["name"]}"),
            const SizedBox(height: 16),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "New Stock Quantity",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (stockController.text.isNotEmpty) {
                final newStock = int.tryParse(stockController.text) ?? 0;
                _updateStock(product["id"], newStock);
                Get.back();
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Stock Product",
      showProfile: true,
      body: Column(
        children: [
          // Filter section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Category filter
                Row(
                  children: [
                    const Text("Category:"),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _selectedCategory ?? "All",
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const Spacer(),
                    // Low stock toggle
                    Row(
                      children: [
                        const Text("Low Stock Only"),
                        Switch(
                          value: _showLowStockOnly,
                          onChanged: (value) {
                            setState(() {
                              _showLowStockOnly = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Summary cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildSummaryCard("Total Products", products.length.toString(), Colors.blue),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  "Low Stock Items", 
                  filteredProducts.where((p) => p["stock"] <= p["minStock"]).length.toString(), 
                  Colors.orange
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Products list
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      "No products found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final isLowStock = product["stock"] <= product["minStock"];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            product["name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text("Category: ${product["category"]}"),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text("Last Updated: ${product["lastUpdated"]}"),
                                  const Spacer(),
                                  if (isLowStock)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "LOW STOCK",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${formatNumber(product["stock"])} ${product["unit"]}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isLowStock ? Colors.red : Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Min: ${product["minStock"]}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _showUpdateStockDialog(product),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Summary card widget
  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
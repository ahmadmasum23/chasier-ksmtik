import 'package:flutter/material.dart';

class BestSellerList extends StatelessWidget {
  final List<Map<String, dynamic>> bestSellers = [
    {"name": "Lipstik Matte Long Lasting", "sold": 1223},
    {"name": "Serum Vitamin C", "sold": 679},
    {"name": "Setting Spray Long Lasting", "sold": 300},
  ];

  BestSellerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Produk Terlaris",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...bestSellers.map(
              (item) => BestSellerItem(
                name: item["name"],
                sold: item["sold"],
              ),
            ),
      ],
    );
  }
}

class BestSellerItem extends StatelessWidget {
  final String name;
  final int sold;

  const BestSellerItem({
    super.key,
    required this.name,
    required this.sold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Text("$sold Terjual", style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
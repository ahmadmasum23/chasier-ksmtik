import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final bool isExpanded;
  final String selectedCategory; 
  final Function(String?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.isExpanded,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: const SizedBox.shrink(),
      secondChild: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 10
            )
          ]
        ),
        child: Column(
          children: [
            _buildFilterOption("See All", null),
            const Divider(),
            ...["makeup", "skincare"].map((c) => 
              Column(
                children: [
                  _buildFilterOption(c, c),
                  if (c != "skincare") const Divider(),
                ],
              )
            ),
          ],
        ),
      ),
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  Widget _buildFilterOption(String title, String? value) {
    // ✅ Handle comparison dengan empty string untuk "See All"
    final bool selected = (value == null && selectedCategory.isEmpty) || 
                         (value != null && selectedCategory == value);
    
    return GestureDetector(
      onTap: () => onCategorySelected(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off, 
              color: Colors.pink
            ),
            const SizedBox(width: 12),
            Text(
              title, 
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.pink : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
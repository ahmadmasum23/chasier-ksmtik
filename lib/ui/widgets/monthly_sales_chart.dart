import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/ui/constants/colors.dart';

class MonthlySalesChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const MonthlySalesChart({super.key, required this.data});

  @override
  State<MonthlySalesChart> createState() => _MonthlySalesChartState();
}

class _MonthlySalesChartState extends State<MonthlySalesChart> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 260,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(widget.data.length, (index) {
              final item = widget.data[index];
              final isHovered = hoveredIndex == index;

              return Expanded(
                child: MouseRegion(
                  onEnter: (_) => setState(() => hoveredIndex = index),
                  onExit: (_) => setState(() => hoveredIndex = null),
                  child: GestureDetector(
                    onTap: () => setState(() => hoveredIndex = index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tooltip
                        AnimatedOpacity(
                          opacity: isHovered ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: isHovered
                              ? Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Rp ${item['value']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              : const SizedBox(height: 16),
                        ),

                        // Bar
                        Container(
                          height: (item['value'] / _maxValue(widget.data)) * 140,
                          width: 22,
                          decoration: BoxDecoration(
                            color: item['active']
                                ? AppColors.colorpenjualan
                                : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Label bulan
                        Text(
                          item['month'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  double _maxValue(List<Map<String, dynamic>> data) {
    return data
        .map((e) => e['value'] as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
  }
}

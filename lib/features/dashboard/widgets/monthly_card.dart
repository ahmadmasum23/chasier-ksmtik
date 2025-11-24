import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';

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
          height: 300,
          child: Stack(
            // Pakai Stack agar tooltip bisa muncul di atas semua bar
            children: [
              // Background bars
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(widget.data.length, (index) {
                  final item = widget.data[index];
                  final height =
                      (item['value'] as int) / _maxValue(widget.data) * 160;

                  return Expanded(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => hoveredIndex = index),
                      onExit: (_) => setState(() => hoveredIndex = null),
                      child: GestureDetector(
                        onTap: () => setState(
                          () => hoveredIndex = hoveredIndex == index
                              ? null
                              : index,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Bar
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: height,
                              width: 28,
                              decoration: BoxDecoration(
                                color: item['active']
                                    ? AppColors.colorpenjualan
                                    : const Color(0xFFE5E7EB),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: hoveredIndex == index
                                    ? [
                                        BoxShadow(
                                          color: AppColors.colorpenjualan
                                              .withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, -4),
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
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

              // TOOLTIP CARD HORIZONTAL (muncul saat hover/tap)
              // TOOLTIP CARD YANG PANJANGNYA MENYESUAIKAN ISI (TIDAK FULL WIDTH)
              if (hoveredIndex != null)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        offset: hoveredIndex != null
                            ? Offset.zero
                            : const Offset(0, -0.3),
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          opacity: hoveredIndex != null ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 280,
                              ), // batas maksimal
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: IntrinsicWidth(
                                // INI KUNCI: biar lebar sesuai isi!
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.colorpenjualan,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.trending_up,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Teks
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.data[hoveredIndex!]['month'],
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Rp ${formatRupiah(widget.data[hoveredIndex!]['value'])}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _maxValue(List<Map<String, dynamic>> data) {
    return data
            .map((e) => e['value'] as int)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        100000; // sedikit buffer
  }

  String formatRupiah(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

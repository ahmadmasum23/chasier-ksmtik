import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';

class CardMingguan extends StatelessWidget {
  const CardMingguan({super.key});

  final double barWidth = 16;

  @override
  Widget build(BuildContext context) {
    final barGroups = [
      makeGroupData(0, 8, 15),
      makeGroupData(1, 10, 12),
      makeGroupData(2, 6, 18),
      makeGroupData(3, 14, 20),
      makeGroupData(4, 16, 17),
      makeGroupData(5, 8, 19),
      makeGroupData(6, 4, 18),
    ];

    return AspectRatio(
      aspectRatio: 1.7,
      child: Stack(
        children: [
          // Chart Utama
          BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 25,
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      const days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(color: AppColors.roseShade, fontWeight: FontWeight.w100, fontSize: 18),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipMargin: 8,
                  getTooltipColor: (_) => Colors.grey.shade700,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final isMakeup = rodIndex == 0;
                    return BarTooltipItem(
                      '${isMakeup ? 'Makeup' : 'Skincare'}\n${rod.toY.toInt()}',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            ),
          ),

          // Legenda di Pojok Kanan Atas
          Positioned(
            top: 2,
            right: 16,
            child: Row(
              children: [
                // Kotak Makeup
                _buildLegendItem(AppColors.makeupColor, 'Makeup'),
                const SizedBox(width: 16),
                // Kotak Skincare
                _buildLegendItem(AppColors.skincareColor, 'Skincare'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.roseShade,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(int x, double makeup, double skincare) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: makeup,
          color: AppColors.makeupColor,
          width: barWidth,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
        BarChartRodData(
          toY: skincare,
          color: AppColors.skincareColor,
          width: barWidth,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
      barsSpace: 6,
    );
  }
}
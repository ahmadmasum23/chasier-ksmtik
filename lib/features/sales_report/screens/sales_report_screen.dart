import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  // Sample sales data - in a real app, this would come from a database or API
  List<Map<String, dynamic>> salesData = [
    {"date": "2025-11-10", "sales": 1200000, "transactions": 15},
    {"date": "2025-11-11", "sales": 1800000, "transactions": 22},
    {"date": "2025-11-12", "sales": 1500000, "transactions": 18},
    {"date": "2025-11-13", "sales": 2200000, "transactions": 25},
    {"date": "2025-11-14", "sales": 2800000, "transactions": 32},
    {"date": "2025-11-15", "sales": 1900000, "transactions": 20},
    {"date": "2025-11-16", "sales": 2500000, "transactions": 28},
    {"date": "2025-11-17", "sales": 3100000, "transactions": 35},
  ];

  // Sample product sales data
  List<Map<String, dynamic>> productSales = [
    {"name": "Lipstik Matte", "sales": 4500000, "quantity": 50},
    {"name": "Serum Vitamin C", "sales": 3200000, "quantity": 32},
    {"name": "Setting Spray", "sales": 2800000, "quantity": 40},
    {"name": "Moisturizer Cream", "sales": 1900000, "quantity": 19},
    {"name": "Foundation Liquid", "sales": 1500000, "quantity": 15},
  ];

  // Report period
  String _selectedPeriod = "7 Days";
  final List<String> periods = ["7 Days", "30 Days", "90 Days"];

  // Calculate total sales
  int get totalSales {
    return salesData.fold(0, (sum, item) => sum + (item["sales"] as int));
  }

  // Calculate total transactions
  int get totalTransactions {
    return salesData.fold(0, (sum, item) => sum + (item["transactions"] as int));
  }

  // Format currency
  String formatCurrency(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return "Rp $formatted";
  }

  // Format date
  String formatDate(String date) {
    final parts = date.split("-");
    if (parts.length == 3) {
      return "${parts[2]}/${parts[1]}";
    }
    return date;
  }

  // Generate bar chart data
  List<BarChartGroupData> _generateBarGroups() {
    List<BarChartGroupData> barGroups = [];
    
    for (int i = 0; i < salesData.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (salesData[i]["sales"] as int).toDouble(),
              color: Colors.pink,
              width: 16,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }
    
    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Sales Report",
      showProfile: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period selector
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: _selectedPeriod,
                    items: periods.map((period) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value!;
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Summary cards
              Row(
                children: [
                  _buildSummaryCard("Total Sales", formatCurrency(totalSales), Colors.green),
                  const SizedBox(width: 16),
                  _buildSummaryCard("Transactions", totalTransactions.toString(), Colors.blue),
                  const SizedBox(width: 16),
                  _buildSummaryCard("Avg. per Transaction", formatCurrency(totalSales ~/ totalTransactions), Colors.orange),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Sales chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sales Chart",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            barGroups: _generateBarGroups(),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= 0 && index < salesData.length) {
                                      return Text(
                                        formatDate(salesData[index]["date"]),
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    }
                                    return const Text("");
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value == 0) return const Text("0");
                                    return Text(formatCurrency(value.toInt()).replaceAll("Rp ", ""));
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: true),
                            barTouchData: BarTouchData(enabled: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Top selling products
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Top Selling Products",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productSales.length,
                        itemBuilder: (context, index) {
                          final product = productSales[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.pink.withOpacity(0.1),
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product["name"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${product["quantity"]} sold",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  formatCurrency(product["sales"]),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
                  fontSize: 18,
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
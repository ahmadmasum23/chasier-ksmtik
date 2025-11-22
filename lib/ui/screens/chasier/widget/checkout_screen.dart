import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/ui/constants/colors.dart';
import 'package:kasir_kosmetic/ui/screens/chasier/widget/success_payment_dialog.dart';

class CheckoutModal extends StatefulWidget {
  final Map<int, int> cart;
  final List<Map<String, dynamic>> products;
  final Function(int productId, int newQty)? onUpdateQuantity;
  final Function(int productId)? onRemoveItem;
  final VoidCallback onPaymentSuccess;

  const CheckoutModal({
    super.key,
    required this.cart,
    required this.products,
    this.onUpdateQuantity,
    this.onRemoveItem,
    required this.onPaymentSuccess,
  });

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  String selectedCustomer = "Walk-in Customer";
  String selectedPayment = "Cash";

  final List<String> customers = [
    "Walk-in Customer",
    "Member A",
    "Member B",
    "Member C",
  ];
  final List<String> payments = ["Cash", "E-Wallet", "Card"];

  // Data produk sesuai dengan gambar
  final List<Map<String, dynamic>> sampleProducts = [
    {
      "name": "Setting Spray Long Lasting",
      "price": 99000,
      "quantity": 4,
      "total": 396000,
    },
    {
      "name": "Lipstik Matte Long Lasting",
      "price": 89000,
      "quantity": 4,
      "total": 356000,
    },
    {
      "name": "Serum Vitamin C",
      "price": 69000,
      "quantity": 2,
      "total": 138000,
    },
  ];

  int get subtotal => 1138000;
  int get totalDiscount => 69000;
  int get total => subtotal - totalDiscount;

  String formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return "Rp $formatted";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: BoxDecoration(
          color: AppColors.bgpubiru,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // HEADER: Pelanggan
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pelanggan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCustomer,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.roseShade,
                          size: 28,
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        items: customers
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedCustomer = v!),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ITEM LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Setting Spray
                  _buildProductItem(
                    name: "Setting Spray Long Lasting",
                    price: 99000,
                    quantity: 4,
                    total: 396000,
                  ),
                  const SizedBox(height: 12),
                  
                  // Lipstik Matte
                  _buildProductItem(
                    name: "Lipstik Matte Long Lasting",
                    price: 89000,
                    quantity: 4,
                    total: 356000,
                  ),
                  const SizedBox(height: 12),
                  
                  // Serum Vitamin C
                  _buildProductItem(
                    name: "Serum Vitamin C",
                    price: 69000,
                    quantity: 2,
                    total: 138000,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DISKON SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 0.5),
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Diskon",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "- ${formatRupiah(totalDiscount)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // METODE PEMBAYARAN SECTION
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Metode Pembayaran",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // PAYMENT METHOD CHIPS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: payments.map((method) {
                  bool active = selectedPayment == method;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedPayment = method),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.softPink
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: active ? AppColors.softPink : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          method,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: active ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // CASH SECTION
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Chas",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // TOTAL SUMMARY
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Subtotal:", formatRupiah(subtotal)),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    "Total Diskon:",
                    "- ${formatRupiah(totalDiscount)}",
                    valueColor: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    "Total:",
                    formatRupiah(total),
                    isBold: true,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    "Bayar",
                    formatRupiah(subtotal),
                    isBold: true,
                  ),
                  const SizedBox(height: 4),
                  _buildSummaryRow(
                    "",
                    "- ${formatRupiah(totalDiscount)}",
                    valueColor: Colors.red,
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // PAY BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => SuccessPaymentDialog(
                        totalAmount: total,
                        paymentMethod: selectedPayment,
                        customerName: selectedCustomer == "Walk-in Customer"
                            ? "Walk-in Customer"
                            : selectedCustomer,
                      ),
                    );
                    widget.onPaymentSuccess();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softPink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Bayar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem({
    required String name,
    required int price,
    required int quantity,
    required int total,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${formatRupiah(price)} / pcs",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              if (quantity > 1)
                Text(
                  "$quantity +",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatRupiah(total),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.softPink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? (isBold ? AppColors.softPink : Colors.black87),
          ),
        ),
      ],
    );
  }
}
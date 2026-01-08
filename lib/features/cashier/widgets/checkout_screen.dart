import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/data/models/pelanggan_model.dart';
import 'package:kasir_kosmetic/data/services/pelanggan_service.dart';
import 'package:kasir_kosmetic/data/services/product_service.dart';
import 'package:kasir_kosmetic/features/cashier/widgets/success_payment_dialog.dart';
import 'package:collection/collection.dart';

class CheckoutModal extends StatefulWidget {
  final Map<int, int> cart;
  final List<ProductModel> products;
  final VoidCallback onPaymentSuccess;

  const CheckoutModal({
    super.key,
    required this.cart,
    required this.products,
    required this.onPaymentSuccess,
  });

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  String selectedCustomer = "Walk-in Customer";
  String selectedPayment = "Cash";
  List<Pelanggan> _pelangganList = [];
  bool _isLoadingPelanggan = true;

  late Map<int, int> localCart;

  final List<String> payments = ["Cash", "E-Wallet", "Card"];

  final TextEditingController _tunaiController = TextEditingController();
  int? _tunaiAmount;

  final PelangganService _pelangganService = PelangganService();

  @override
  void initState() {
    super.initState();
    localCart = Map.from(widget.cart);
    _loadPelanggan();
  }

  @override
  void dispose() {
    _tunaiController.dispose();
    super.dispose();
  }

  Future<void> _loadPelanggan() async {
    try {
      final pelanggans = await _pelangganService.getAllPelanggan();
      if (mounted) {
        setState(() {
          _pelangganList = pelanggans;
          _isLoadingPelanggan = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPelanggan = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat pelanggan: $e")),
      );
    }
  }

  List<String> get customerOptions {
    final names = _pelangganList.map((p) => p.nama).toList();
    return ["Walk-in Customer", ...names];
  }

  int get subtotal {
    int total = 0;
    localCart.forEach((id, qty) {
      final product = widget.products.firstWhereOrNull((p) => p.id == id);
      if (product != null) {
        total += product.hargaJual.toInt() * qty;
      }
    });
    return total;
  }

  int get totalDiscount => 0;
  int get total => subtotal - totalDiscount;
  int? get kembalian => _tunaiAmount != null ? _tunaiAmount! - total : null;

  String formatRupiah(int amount) {
    if (amount == 0) return "Rp 0";
    return "Rp ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}";
  }

  void _updateQty(int productId, int newQty) {
    final product = widget.products.firstWhereOrNull((p) => p.id == productId);
    if (product == null) return;

    final maxQty = product.stok;
    if (newQty > maxQty) {
      // ✅ Gunakan pop-up, bukan SnackBar
      _showStockExceededDialog(context, product);
      return;
    }

    if (newQty <= 0) {
      setState(() {
        localCart.remove(productId);
      });
    } else {
      setState(() {
        localCart[productId] = newQty;
      });
    }
  }

  void _onTunaiChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _tunaiAmount = null;
      });
      return;
    }
    final clean = value.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.isEmpty) {
      _tunaiAmount = null;
      return;
    }
    setState(() {
      _tunaiAmount = int.parse(clean);
    });
  }

  // ✅ Validasi dan kurangi stok di database
  Future<bool> _validateAndReduceStock() async {
    for (final entry in localCart.entries) {
      final productId = entry.key;
      final qtyToBuy = entry.value;
      final product = widget.products.firstWhereOrNull((p) => p.id == productId);
      if (product == null) {
        _showStockExceededDialog(context, ProductModel(
          id: productId,
          nama: 'Produk Tidak Ditemukan',
          hargaBeli: 0,
          hargaJual: 0,
          stok: 0,
          dibuatPada: DateTime.now(),
          kategori: '',
        ));
        return false;
      }
      if (product.stok < qtyToBuy) {
        _showStockExceededDialog(context, product);
        return false;
      }
    }

    final productService = ProductService();
    for (final entry in localCart.entries) {
      final productId = entry.key;
      final qtyToBuy = entry.value;
      final product = widget.products.firstWhere((p) => p.id == productId);
      final newStock = product.stok - qtyToBuy;

      final success = await productService.updateStock(productId, newStock);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengupdate stok untuk: ${product.nama}")),
        );
        return false;
      }
    }
    return true;
  }

  // ✅ POP-UP UNTUK STOK TIDAK CUKUP / HABIS
  void _showStockExceededDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          product.stok == 0 ? "Stok Habis" : "Stok Tidak Mencukupi",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          product.stok == 0
              ? "Maaf, stok ${product.nama} sudah habis."
              : "Stok ${product.nama} hanya tersedia ${product.stok}.",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Mengerti", style: TextStyle(color: AppColors.softPink)),
          ),
        ],
      ),
    );
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
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
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
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                  ),
                ],
              ),
            ),

            // DROPDOWN CUSTOMER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _isLoadingPelanggan
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
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
                          items: customerOptions
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => selectedCustomer = v!),
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // ITEM LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: localCart.entries.map((entry) {
                  final productId = entry.key;
                  final qty = entry.value;
                  final product = widget.products.firstWhereOrNull((p) => p.id == productId);
                  if (product == null) return const SizedBox.shrink();
                  final price = product.hargaJual.toInt();
                  final totalItem = price * qty;
                  final maxQty = product.stok;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.nama,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${formatRupiah(price)} / pcs",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      "Stok tersedia: $maxQty",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: maxQty == 0 ? Colors.red : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: qty > 1
                                        ? () => _updateQty(productId, qty - 1)
                                        : null,
                                    icon: Icon(
                                      Icons.remove,
                                      size: 20,
                                      color: qty > 1 ? null : Colors.grey,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    splashRadius: 20,
                                  ),
                                  Text(
                                    "$qty",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // ✅ TOMBOL PLUS: SELALU BISA DI-KLIK, TAPI VALIDASI DI DALAM
                                  IconButton(
                                    onPressed: () {
                                      if (qty >= maxQty) {
                                        _showStockExceededDialog(context, product);
                                        return;
                                      }
                                      _updateQty(productId, qty + 1);
                                    },
                                    icon: const Icon(Icons.add, size: 20),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    splashRadius: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total:",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                formatRupiah(totalItem),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.softPink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () => _updateQty(productId, 0),
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashRadius: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // 💳 CARD RINGKASAN PEMBAYARAN (SEMUA DALAM SATU)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subtotal
                  _buildSummaryRow("Subtotal:", formatRupiah(subtotal)),

                  const SizedBox(height: 8),

                  // Diskon
                  _buildSummaryRow(
                    "Diskon:",
                    "- ${formatRupiah(totalDiscount)}",
                    valueColor: Colors.red,
                  ),

                  const SizedBox(height: 12),
                  Container(height: 1, color: Colors.grey.shade300),
                  const SizedBox(height: 12),

                  // Total
                  _buildSummaryRow("Total:", formatRupiah(total), isBold: true),

                  const SizedBox(height: 16),

                  // METODE PEMBAYARAN
                  const Text(
                    "Metode Pembayaran",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: payments.map((method) {
                      bool active = selectedPayment == method;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            selectedPayment = method;
                            if (method != "Cash") {
                              _tunaiController.clear();
                              _tunaiAmount = null;
                            }
                          }),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: active ? AppColors.softPink : Colors.grey.shade100,
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
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // 🔸 CASH: INPUT TUNAI + KEMBALIAN
                  if (selectedPayment == "Cash") ...[
                    const Text(
                      "Tunai",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _tunaiController,
                      onChanged: _onTunaiChanged,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Masukkan jumlah uang",
                        prefixText: "Rp ",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (_tunaiAmount != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Kembalian:", style: TextStyle(color: Colors.grey)),
                          Text(
                            kembalian! >= 0
                                ? formatRupiah(kembalian!)
                                : "Uang tidak cukup",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kembalian! >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],

                  // 🔸 E-WALLET
                  if (selectedPayment == "E-Wallet") ...[
                    const SizedBox(height: 12),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.qr_code, size: 50, color: AppColors.roseShade),
                          const SizedBox(height: 8),
                          const Text("Scan QR untuk Bayar", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],

                  // 🔸 CARD
                  if (selectedPayment == "Card") ...[
                    const SizedBox(height: 12),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.credit_card, size: 50, color: AppColors.roseShade),
                          const SizedBox(height: 8),
                          const Text("Tap atau Masukkan Kartu", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
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
                  onPressed: () async {
                    if (selectedPayment == "Cash") {
                      if (_tunaiAmount == null || _tunaiAmount! < total) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Jumlah tunai tidak cukup!")),
                        );
                        return;
                      }
                    }

                    final stockValid = await _validateAndReduceStock();
                    if (!stockValid) {
                      return;
                    }

                    Navigator.of(context).pop();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => SuccessPaymentDialog(
                          totalAmount: total,
                          paymentMethod: selectedPayment,
                          customerName: selectedCustomer,
                          cart: localCart,
                          products: widget.products,
                          changeAmount: kembalian,
                        ),
                      );
                    });
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
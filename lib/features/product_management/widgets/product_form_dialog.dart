import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'dart:io';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/features/product_management/controller/product_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:intl/intl.dart';
import 'package:kasir_kosmetic/core/widgets/app_alert.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductController controller;
  final ProductModel? product;

  const ProductFormDialog({super.key, required this.controller, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _purchasePriceCtrl = TextEditingController();
  final TextEditingController _stockCtrl = TextEditingController();

  String? _selectedCategory;
  File? _selectedImageFile;
  Uint8List? _selectedImageWeb;
  final ImagePicker _imagePicker = ImagePicker();
  bool warned = false;

  String _extractNumber(String input) {
    return input.replaceAll(RegExp(r'[^\d]'), '');
  }

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initializeForm(widget.product!);
    }
  }

  void _initializeForm(ProductModel product) {
    _nameCtrl.text = product.nama;
    _stockCtrl.text = product.stok.toString();
    _selectedCategory = product.kategori;

    // Saat edit, tampilkan langsung format Rp
    _priceCtrl.text =
        'Rp ${NumberFormat('#,##0', 'id_ID').format(product.hargaJual.toInt())}';
    _purchasePriceCtrl.text =
        'Rp ${NumberFormat('#,##0', 'id_ID').format(product.hargaBeli.toInt())}';
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageWeb = bytes;
            _selectedImageFile = null;
          });
        } else {
          setState(() {
            _selectedImageFile = File(image.path);
            _selectedImageWeb = null;
          });
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _saveProduct() async {
    if (_nameCtrl.text.isEmpty) {
      AppAlert.warning(context, "Nama produk wajib diisi.");
      return;
    }

    if (_selectedCategory == null) {
      AppAlert.warning(context, "Kategori belum dipilih.");
      return;
    }

    if (_priceCtrl.text.isEmpty) {
      AppAlert.warning(context, "Harga jual wajib diisi.");
      return;
    }

    if (_purchasePriceCtrl.text.isEmpty) {
      AppAlert.warning(context, "Harga beli wajib diisi.");
      return;
    }

    if (_stockCtrl.text.isEmpty) {
      AppAlert.warning(context, "Stok masih kosong.");
      return;
    }
    if (double.tryParse(_extractNumber(_priceCtrl.text)) == null) {
      AppAlert.warning(context, "Harga jual hanya boleh angka.");
      return;
    }

    if (double.tryParse(_extractNumber(_purchasePriceCtrl.text)) == null) {
      AppAlert.warning(context, "Harga beli hanya boleh angka.");
      return;
    }

    if (int.tryParse(_stockCtrl.text) == null) {
      AppAlert.warning(context, "Stok hanya boleh angka.");
      return;
    }

    try {
      String? imageUrl = await _uploadImageToServer();
      if (imageUrl == null && widget.product != null) {
        imageUrl = widget.product!.urlGambar;
      }

      final hargaJual = double.tryParse(_extractNumber(_priceCtrl.text)) ?? 0.0;
      final hargaBeli =
          double.tryParse(_extractNumber(_purchasePriceCtrl.text)) ?? 0.0;
      final stok = int.tryParse(_stockCtrl.text) ?? 0;

      bool success;
      if (widget.product == null) {
        final product = ProductModel(
          id: 0,
          nama: _nameCtrl.text,
          hargaJual: hargaJual,
          hargaBeli: hargaBeli,
          stok: stok,
          urlGambar: imageUrl,
          dibuatPada: DateTime.now(),
          kategori: _selectedCategory,
        );
        success = await widget.controller.addProduct(product);
      } else {
        final product = ProductModel(
          id: widget.product!.id,
          nama: _nameCtrl.text,
          hargaJual: hargaJual,
          hargaBeli: hargaBeli,
          stok: stok,
          urlGambar: imageUrl,
          dibuatPada: widget.product!.dibuatPada,
          kategori: _selectedCategory,
        );
        success = await widget.controller.updateProduct(product);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error saving product: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<String?> _uploadImageToServer() async {
    if (!_hasSelectedImage()) return null;

    try {
      Uint8List imageBytes;
      if (kIsWeb) {
        imageBytes = _selectedImageWeb!;
      } else {
        imageBytes = await _selectedImageFile!.readAsBytes();
      }

      final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageUrl = await widget.controller.uploadProductImage(
        imageBytes,
        fileName,
      );
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal upload gambar: $e')));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product == null ? "Tambah Produk Baru" : "Edit Produk",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),

                // Nama Produk
                _buildInputField(
                  controller: _nameCtrl,
                  placeholder: "Nama Produk",
                ),
                const SizedBox(height: 16),

                // Kategori
                _buildCategoryDropdown(),
                const SizedBox(height: 16),

                // Harga Jual (khusus format Rupiah)
                _buildRupiahField(
                  controller: _priceCtrl,
                  hint: "Harga jual Rp",
                ),
                const SizedBox(height: 16),

                // Harga Beli (khusus format Rupiah)
                _buildRupiahField(
                  controller: _purchasePriceCtrl,
                  hint: "Harga beli Rp",
                ),
                const SizedBox(height: 16),

                // Stok
                _buildInputField(
                  controller: _stockCtrl,
                  placeholder: "Stok",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // Upload Gambar
                _buildImageUploadSection(),
                const SizedBox(height: 54),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.makeupColor,
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      widget.product == null ? "Tambah Produk" : "Simpan",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Tutup (X)
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: "Tutup",
            ),
          ),
        ],
      ),
    );
  }

  // === WIDGET: Input Biasa (Nama, Stok) ===
  Widget _buildInputField({
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // === WIDGET: Input Khusus Rupiah (Harga Jual & Beli) ===
  Widget _buildRupiahField({
    required TextEditingController controller,
    required String hint,
  }) {
    // Cek apakah field sudah berisi angka (bukan hanya "Rp ")
    bool hasValue =
        controller.text.isNotEmpty &&
        controller.text != 'Rp ' &&
        controller.text.length > 3;

    return Container(
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint, // Misal: "Harga jual (contoh: Rp 25.000)"
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: (rawInput) {
          // String numericOnly = rawInput.replaceAll(RegExp(r'[^\d]'), '');

          // if (numericOnly.isEmpty) {
          //   // Kosongkan teks → biarkan hint muncul
          //   controller.text = '';
          //   return;
          // }
          if (RegExp(r'[A-Za-z]').hasMatch(rawInput)) {
            if (!warned) {
              warned = true;
              AppAlert.warning(context, "Hanya boleh angka!");
            }
          } else {
            warned = false;
          }

          String formatted = NumberFormat(
            '#,##0',
            'id_ID',
          ).format(int.tryParse ?? 0);
          String result = 'Rp $formatted';

          controller.text = result;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: result.length),
          );
        },
      ),
    );
  }

  // === WIDGET: Dropdown Kategori ===
  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          hintText: "Kategori",
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        items: widget.controller.categories
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: (v) => setState(() => _selectedCategory = v),
      ),
    );
  }

  // === WIDGET: Upload Gambar ===
  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.makeupColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                child: _buildImagePreview(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    // Jika ada gambar yang dipilih
    if (_hasSelectedImage()) {
      Widget imageWidget;
      if (kIsWeb && _selectedImageWeb != null) {
        imageWidget = Image.memory(_selectedImageWeb!, fit: BoxFit.cover);
      } else if (!kIsWeb && _selectedImageFile != null) {
        imageWidget = Image.file(_selectedImageFile!, fit: BoxFit.cover);
      } else {
        imageWidget = _buildPlaceholder();
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: imageWidget,
      );
    }

    // Jika edit & ada gambar lama
    if (widget.product?.urlGambar != null &&
        !widget.product!.urlGambar!.startsWith('blob:')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          widget.product!.urlGambar!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }

    // Placeholder default
    return _buildPlaceholder();
  }

  bool _hasSelectedImage() {
    return (kIsWeb && _selectedImageWeb != null) ||
        (!kIsWeb && _selectedImageFile != null);
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 90, color: Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          "Upload Gambar",
          style: TextStyle(fontSize: 20, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _purchasePriceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }
}

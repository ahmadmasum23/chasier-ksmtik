import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/features/product_management/controller/product_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;

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

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initializeForm(widget.product!);
    }
  }

  void _initializeForm(ProductModel product) {
    _nameCtrl.text = product.nama;
    _priceCtrl.text = product.hargaJual.toInt().toString();
    _purchasePriceCtrl.text = product.hargaBeli.toInt().toString();
    _stockCtrl.text = product.stok.toString();
    _selectedCategory = product.kategori;
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
    // Validasi input
    if (_nameCtrl.text.isEmpty ||
        _priceCtrl.text.isEmpty ||
        _purchasePriceCtrl.text.isEmpty ||
        _stockCtrl.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Semua field harus diisi')));
      return;
    }

    try {
      // ✅ UPLOAD GAMBAR KE SERVER ATAU GUNAKAN NULL
      String? imageUrl = await _uploadImageToServer();

      // Jika tidak ada gambar yang diupload, gunakan gambar existing untuk edit
      if (imageUrl == null && widget.product != null) {
        imageUrl = widget.product!.urlGambar;
      }

      // Parse data dengan error handling
      final hargaJual =
          double.tryParse(_priceCtrl.text.replaceAll(".", "")) ?? 0.0;
      final hargaBeli =
          double.tryParse(_purchasePriceCtrl.text.replaceAll(".", "")) ?? 0.0;
      final stok = int.tryParse(_stockCtrl.text) ?? 0;

      bool success;
      if (widget.product == null) {
        // ✅ TAMBAH PRODUK BARU - BUAT OBJEK LANGSUNG
        final product = ProductModel(
          id: 0, // ID akan di-generate oleh database
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
        // ✅ EDIT PRODUK
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

    // ✅ PASTIKAN HANYA NAMA FILE, TANPA PATH
    final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    print('📤 Uploading image: $fileName');
    
    // Upload ke Supabase Storage via controller
    final imageUrl = await widget.controller.uploadProductImage(imageBytes, fileName);
    
    print('✅ Upload result: $imageUrl');
    
    return imageUrl;
  } catch (e) {
    print('Error uploading image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal upload gambar: $e'))
    );
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.product == null ? "Tambah Produk Baru" : "Edit Produk",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Image Upload Section
            _buildImageUploadSection(),
            const SizedBox(height: 16),

            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nama Produk",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
              ),
              items: widget.controller.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga Jual",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Hanya allow angka
                if (value.isNotEmpty &&
                    double.tryParse(value.replaceAll(".", "")) == null) {
                  _priceCtrl.text = _priceCtrl.text.substring(
                    0,
                    _priceCtrl.text.length - 1,
                  );
                  _priceCtrl.selection = TextSelection.fromPosition(
                    TextPosition(offset: _priceCtrl.text.length),
                  );
                }
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _purchasePriceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga Beli",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stok",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveProduct,
                child: Text(
                  widget.product == null ? "Tambah Produk" : "Update Produk",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gambar Produk",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: _buildImagePreview(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _hasSelectedImage() ? "Gambar dipilih" : "Klik untuk upload gambar",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    // Tampilkan gambar yang dipilih
    if (_hasSelectedImage()) {
      if (kIsWeb && _selectedImageWeb != null) {
        return Image.memory(_selectedImageWeb!, fit: BoxFit.cover);
      } else if (!kIsWeb && _selectedImageFile != null) {
        return Image.file(_selectedImageFile!, fit: BoxFit.cover);
      }
    }

    // Tampilkan gambar existing dari produk
    if (widget.product?.urlGambar != null &&
        !widget.product!.urlGambar!.startsWith('blob:')) {
      return Image.network(
        widget.product!.urlGambar!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    // Default placeholder
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
        Icon(Icons.camera_alt, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text("Upload Gambar", style: TextStyle(color: Colors.grey.shade500)),
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

import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/data/models/product_model.dart';
import 'package:kasir_kosmetic/data/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = ''.obs;
  
  final List<String> categories = ["makeup", "skincare"];

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final data = await _productService.getAllProducts();
      products.assignAll(data);
      filteredProducts.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat produk: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String? category) {
    selectedCategory.value = category ?? '';
    if (category == null || category.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((p) => p.kategori == category).toList()
      );
    }
  }

  Future<bool> addProduct(ProductModel product) async {
    try {
      final productToAdd = ProductModel(
        id: 0,
        nama: product.nama,
        hargaJual: product.hargaJual,
        hargaBeli: product.hargaBeli,
        stok: product.stok,
        urlGambar: product.urlGambar,
        dibuatPada: DateTime.now(),
        kategori: product.kategori,
      );

      final success = await _productService.addProduct(productToAdd);
      if (success) {
        await loadProducts();
        Get.snackbar("Sukses", "Produk berhasil ditambahkan");
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", "Gagal menambah produk: $e");
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    try {
      final success = await _productService.updateProduct(product);
      if (success) {
        await loadProducts();
        Get.snackbar("Sukses", "Produk berhasil diupdate");
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", "Gagal mengupdate produk: $e");
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final success = await _productService.deleteProduct(id.toString());
      if (success) {
        await loadProducts();
        Get.snackbar("Sukses", "Produk berhasil dihapus");
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus produk: $e");
      return false;
    }
  }

  String formatRupiah(num number) {
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  // ✅ PERBAIKI METHOD INI - JANGAN KOSONG
  Future<String?> uploadProductImage(Uint8List imageBytes, String fileName) async {
    try {
      print('🔼 Mulai upload gambar: $fileName');
      final imageUrl = await _productService.uploadImageToStorage(imageBytes, fileName);
      print('✅ Upload berhasil: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('❌ Error upload gambar: $e');
      Get.snackbar("Error", "Gagal upload gambar: $e");
      return null;
    }
  }
}
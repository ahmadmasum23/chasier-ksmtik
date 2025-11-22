// Placeholder for Product Repository
// Add supabase_flutter to pubspec.yaml to enable this functionality

import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductRepository {
  final ProductService _productService = ProductService();

  Future<List<ProductModel>> getAllProducts() async {
    return await _productService.getAllProducts();
  }

  Future<ProductModel?> getProductById(String id) async {
    return await _productService.getProductById(id);
  }

  Future<void> addProduct(ProductModel product) async {
    await _productService.addProduct(product);
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productService.updateProduct(product);
  }

  Future<void> deleteProduct(String id) async {
    await _productService.deleteProduct(id);
  }
}
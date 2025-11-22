import '../models/product_model.dart';
import '../../core/utils/supabase_helper.dart';

class ProductService {
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final data = await SupabaseHelper.fetchTableData('products');
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      // Handle error
      return [];
    }
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      final data = await SupabaseHelper.fetchTableData('products');
      final productData = data.firstWhere((product) => product['id'] == id, orElse: () => null);
      if (productData != null) {
        return ProductModel.fromJson(productData);
      }
      return null;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await SupabaseHelper.insertData('products', product.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await SupabaseHelper.updateData('products', product.id, product.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await SupabaseHelper.deleteData('products', id);
    } catch (e) {
      // Handle error
      throw Exception('Failed to delete product: $e');
    }
  }
}
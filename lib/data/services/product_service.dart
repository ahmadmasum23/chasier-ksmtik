import 'package:kasir_kosmetic/core/services/supabase_client.dart';
import '../models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final SupabaseClient _client = SupabaseClientService.instance;

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _client
          .from('produk')
          .select()
          .order('dibuat_pada', ascending: false);  // ← FIX NAMA KOLOM

      return response
          .map<ProductModel>((item) => ProductModel.fromJson(item))
          .toList();
    } catch (e) {
      print("Error getAllProducts: $e");
      return [];
    }
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      final data = await _client
          .from('produk')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (data == null) return null;

      return ProductModel.fromJson(data);
    } catch (e) {
      print("Error getProductById: $e");
      return null;
    }
  }

  // product_service.dart

Future<bool> addProduct(ProductModel product) async {
  try {
    await _client
        .from('produk')
        .insert(product.toJson(includeId: false)); // ← JANGAN KIRIM ID!
    return true;
  } catch (e) {
    print("Error addProduct: $e");
    return false;
  }
}

Future<bool> updateProduct(ProductModel product) async {
  try {
    await _client
        .from('produk')
        .update(product.toJson(includeId: true)) // ← UPDATE BOLEH KIRIM ID
        .eq('id', product.id);
    return true;
  } catch (e) {
    print("Error updateProduct: $e");
    return false;
  }
}

  Future<bool> deleteProduct(String id) async {
    try {
      await _client.from('produk').delete().eq('id', id);
      return true;
    } catch (e) {
      print("Error deleteProduct: $e");
      return false;
    }
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart'; // untuk mobile

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
          .order('dibuat_pada', ascending: false);

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

  Future<bool> addProduct(ProductModel product) async {
    try {
      await _client
          .from('produk')
          .insert(product.toJson(includeId: false));
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
          .update(product.toJson(includeId: true))
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

  // Di ProductService - GANTI method uploadImageToStorage
Future<String?> uploadImageToStorage(Uint8List imageBytes, String fileName) async {
  try {
    print('📤 Uploading to Supabase Storage: $fileName');
    
    // ✅ PASTIKAN fileName TIDAK ADA PATH, HANYA NAMA FILE
    final cleanFileName = fileName.replaceAll('images/', ''); // Hapus prefix images/ jika ada
    
    if (kIsWeb) {
      final response = await _client.storage
          .from('images')
          .uploadBinary(
            cleanFileName, // ✅ GUNAKAN cleanFileName
            imageBytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      print('✅ File uploaded: $response');

      // ✅ GET PUBLIC URL YANG BENAR
      final publicUrl = _client.storage
          .from('images')
          .getPublicUrl(cleanFileName); // ✅ GUNAKAN cleanFileName

      print('🌐 Public URL: $publicUrl');
      
      return publicUrl;
    } else {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$cleanFileName');
      await tempFile.writeAsBytes(imageBytes);
      
      final response = await _client.storage
          .from('images')
          .upload(
            cleanFileName, // ✅ GUNAKAN cleanFileName
            tempFile,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      await tempFile.delete();

      print('✅ File uploaded: $response');

      final publicUrl = _client.storage
          .from('images')
          .getPublicUrl(cleanFileName); // ✅ GUNAKAN cleanFileName

      print('🌐 Public URL: $publicUrl');
      
      return publicUrl;
    }
  } catch (e) {
    print('❌ Error uploading to Supabase Storage: $e');
    rethrow;
  }
}
}
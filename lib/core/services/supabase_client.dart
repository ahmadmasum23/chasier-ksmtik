// supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/config/supabase_config.dart';
import 'package:kasir_kosmetic/data/services/product_service.dart';

class SupabaseClientService {
  static SupabaseClient? _instance;

  static SupabaseClient get instance {
    if (_instance == null) {
      throw Exception('Supabase client not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  static Future<void> initialize() async {
  if (_instance != null) return;

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  _instance = Supabase.instance.client;

  // // TES LANGSUNG TANPA MODEL (ini pasti muncul data kalau tabel benar)
  // try {
  //   final response = await _instance!
  //       .from('produk')
  //       .select()
  //       .order('dibuat_pada', ascending: false);

  //   print("=== RAW DATA DARI SUPABASE (tanpa model) ===");
  //   print(response); // ini pasti muncul kalau ada data
  //   print("Total baris: ${response.length}");

  //   for (var item in response) {
  //     print("ID: ${item['id']} | "
  //         "Nama: ${item['nama']} | "
  //         "Harga Jual: ${item['harga_jual']} | "
  //         "Stok: ${item['stok']} | "
  //         "Kategori: ${item['kategori']}");
  //   }
  // } catch (e) {
  //   print("Error query langsung: $e");
  // }
}

  static bool get isInitialized => _instance != null;
}
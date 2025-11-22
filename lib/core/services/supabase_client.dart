import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/config/supabase_config.dart';

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
  }

  static bool get isInitialized => _instance != null;
}
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kasir_kosmetic/core/services/supabase_client.dart';
import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await SupabaseClientService.initialize();
  runApp(const MyApp());
}
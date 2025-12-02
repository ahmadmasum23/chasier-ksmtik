// import 'package:kasir_kosmetic/core/services/supabase_client.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class SupabaseHelper {
//   static SupabaseClient get client {
//     if (!SupabaseClientService.isInitialized) {
//       throw Exception('Supabase client not initialized. Make sure to call SupabaseClientService.initialize() first.');
//     }
//     return SupabaseClientService.instance;
//   }

//   static Future<Map<String, dynamic>?> getCurrentUser() async {
//     final user = SupabaseClientService.instance.auth.currentUser;
//     if (user != null) {
//       try {
//         final response = await SupabaseClientService.instance
//             .from('users')
//             .select()
//             .eq('id', user.id)
//             .single();
        
//         return response as Map<String, dynamic>?;
//       } catch (e) {
//         throw Exception('Error fetching user: $e');
//       }
//     }
//     return null;
//   }

//   static Future<List<dynamic>> fetchTableData(String tableName) async {
//     try {
//       final response = await SupabaseClientService.instance
//           .from(tableName)
//           .select();
      
//       return response as List<dynamic>;
//     } catch (e) {
//       throw Exception('Error fetching data: $e');
//     }
//   }

//   static Future<void> insertData(
//       String tableName, Map<String, dynamic> data) async {
//     try {
//       await SupabaseClientService.instance
//           .from(tableName)
//           .insert(data);
//     } catch (e) {
//       throw Exception('Error inserting data: $e');
//     }
//   }

//   static Future<void> updateData(
//       String tableName, String id, Map<String, dynamic> data) async {
//     try {
//       await SupabaseClientService.instance
//           .from(tableName)
//           .update(data)
//           .eq('id', id);
//     } catch (e) {
//       throw Exception('Error updating data: $e');
//     }
//   }

//   static Future<void> deleteData(String tableName, String id) async {
//     try {
//       await SupabaseClientService.instance
//           .from(tableName)
//           .delete()
//           .eq('id', id);
//     } catch (e) {
//       throw Exception('Error deleting data: $e');
//     }
//   }
// }
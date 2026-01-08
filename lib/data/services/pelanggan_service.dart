import 'package:kasir_kosmetic/core/services/supabase_client.dart';
import 'package:kasir_kosmetic/data/models/pelanggan_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganService {
  final SupabaseClient _client = SupabaseClientService.instance;

  Future<List<Pelanggan>> getAllPelanggan({String? searchQuery}) async {
    try {
      var query = _client.from('pelanggan').select();

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.ilike('nama', '%$searchQuery%');
      }

      final response = await query.order('dibuat_pada', ascending: false);

      final List<dynamic> data = response as List<dynamic>;

      return data
          .map((e) => Pelanggan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Pelanggan> createPelanggan({
    required String nama,
    required String nomorHp,
    String? email,
    String? alamat,
    String? jenisKelamin,
  }) async {
    try {
      final response = await _client
          .from('pelanggan')
          .insert({
            'nama': nama,
            'nomor_hp': nomorHp,
            'email': email,
            'alamat': alamat,
            'jenis_kelamin': jenisKelamin,
            'total_pembelian': 0,
          })
          .select()
          .single();

      return Pelanggan.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Pelanggan> updatePelanggan(Pelanggan pelanggan) async {
    try {
      final response = await _client
          .from('pelanggan')
          .update({
            'nama': pelanggan.nama,
            'nomor_hp': pelanggan.nomorHp,
            'email': pelanggan.email,
            'alamat': pelanggan.alamat,
            'jenis_kelamin': pelanggan.jenisKelamin,
            'total_pembelian': pelanggan.totalPembelian,
            'diperbarui_pada': DateTime.now().toIso8601String(),
          })
          .eq('id', pelanggan.id)
          .select()
          .single();

      return Pelanggan.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePelanggan(int id) async {
    try {
      await _client.from('pelanggan').delete().eq('id', id);
    } catch (e) {
      rethrow;
    }
  }
}

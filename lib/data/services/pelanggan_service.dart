import 'package:kasir_kosmetic/core/services/supabase_client.dart';
import 'package:kasir_kosmetic/data/models/pelanggan_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganService {
  final SupabaseClient _client = SupabaseClientService.instance;

  Future<List<Pelanggan>> getAllPelanggan({String? searchQuery}) async {
    print(' [PelangganService] Memuat data pelanggan...');

    try {
      var query = _client.from('pelanggan').select();

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        print(' [PelangganService] Cari: "$searchQuery"');
        query = query.ilike('nama', '%$searchQuery%');
      }

      final response = await query.order('dibuat_pada', ascending: false);

      if (response == null) {
        print(' [PelangganService] Response null');
        return [];
      }

      final List<dynamic> data = response as List<dynamic>;
      print(' [PelangganService] Berhasil memuat ${data.length} pelanggan');

      final List<Pelanggan> list = data
          .map((e) => Pelanggan.fromJson(e as Map<String, dynamic>))
          .toList();

      if (list.isNotEmpty) {
        print('📌 Contoh data: id=${list[0].id}, nama=${list[0].nama}');
      }

      return list;
    } catch (e, stack) {
      print('❌ [PelangganService] ERROR saat getAllPelanggan:');
      print('   Error: $e');
      print('   Stack: $stack');
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
    print('➕ [PelangganService] Menambah pelanggan: $nama');
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

      final pelanggan = Pelanggan.fromJson(response as Map<String, dynamic>);
      print('✅ [PelangganService] Berhasil tambah pelanggan: ${pelanggan.id}');
      return pelanggan;
    } catch (e, stack) {
      print('❌ [PelangganService] ERROR saat createPelanggan:');
      print('   Error: $e');
      print('   Stack: $stack');
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

      return Pelanggan.fromJson(response as Map<String, dynamic>);
    } catch (e, stack) {
      print('❌ Error update: $e');
      rethrow;
    }
  }

  Future<void> deletePelanggan(int id) async {
    print('🗑️ [PelangganService] Hapus pelanggan ID: $id');
    try {
      await _client.from('pelanggan').delete().eq('id', id);
      print('✅ [PelangganService] Berhasil hapus pelanggan');
    } catch (e, stack) {
      print('❌ [PelangganService] ERROR saat deletePelanggan:');
      print('   Error: $e');
      print('   Stack: $stack');
      rethrow;
    }
  }
}

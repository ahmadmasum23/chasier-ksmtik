import 'package:get/get.dart';
import 'package:kasir_kosmetic/data/models/pelanggan_model.dart';
import 'package:kasir_kosmetic/data/services/pelanggan_service.dart';
import 'package:flutter/material.dart';

class PelangganController extends GetxController {
  final PelangganService _service = PelangganService();
  final RxList<Pelanggan> _pelangganList = <Pelanggan>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _loading = false.obs;

  List<Pelanggan> get pelangganList => _pelangganList;
  bool get loading => _loading.value;

  @override
  void onInit() {
    super.onInit();
    fetchAllPelanggan();
  }

  Future<void> fetchAllPelanggan() async {
    _loading.value = true;
    update();

    try {
      final data = await _service.getAllPelanggan(searchQuery: _searchQuery.value);
      _pelangganList.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data pelanggan");
    } finally {
      _loading.value = false;
      update();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery.value = value;
    fetchAllPelanggan(); // auto reload saat ketik
  }

  Future<void> addPelanggan({
  required String nama,
  required String nomorHp,
  String? email,
  String? alamat,
  String? jenisKelamin, // ✅
}) async {
  try {
    await _service.createPelanggan(
      nama: nama,
      nomorHp: nomorHp,
      email: email,
      alamat: alamat,
      jenisKelamin: jenisKelamin, // ✅
    );
    await fetchAllPelanggan();
  } catch (e) {
    Get.snackbar("Error", "Gagal menambah pelanggan");
  }
}

  Future<void> updatePelanggan(Pelanggan pelanggan) async {
    try {
      await _service.updatePelanggan(pelanggan);
      await fetchAllPelanggan();
    } catch (e) {
      Get.snackbar("Error", "Gagal mengupdate pelanggan");
    }
  }

  Future<void> deletePelanggan(int id) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Hapus Pelanggan?"),
        content: const Text("Pelanggan ini akan dihapus permanen."),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await _service.deletePelanggan(id);
        await fetchAllPelanggan();
      } catch (e) {
        Get.snackbar("Error", "Gagal menghapus pelanggan");
      }
    }
  }
}
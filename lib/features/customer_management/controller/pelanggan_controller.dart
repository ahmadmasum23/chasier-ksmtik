import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/data/models/pelanggan_model.dart';
import 'package:kasir_kosmetic/data/services/pelanggan_service.dart';
import 'package:kasir_kosmetic/features/auth/widgets/custom_dialog.dart';

class PelangganController extends GetxController {
  final PelangganService _service = PelangganService();

  final RxList<Pelanggan> pelangganList = <Pelanggan>[].obs;
  final RxBool loading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPelanggan();
  }

  // =========================================================
  //                    VALIDASI EMAIL
  // =========================================================
  bool isValidEmail(String email) {
    if (email.isEmpty) return true; // Email opsional → dianggap valid
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  // =========================================================
  //                 FETCH DATA PELANGGAN
  // =========================================================
  Future<void> fetchAllPelanggan() async {
    loading.value = true;

    try {
      final data = await _service.getAllPelanggan(searchQuery: searchQuery.value);
      pelangganList.assignAll(data);
    } catch (e) {
      CustomDialog.show(
        title: "Gagal Memuat",
        message: "Terjadi kesalahan saat memuat data pelanggan.",
        type: DialogType.error,
      );
    } finally {
      loading.value = false;
    }
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
    fetchAllPelanggan();
  }

  // =========================================================
  //                 VALIDASI SEBELUM TAMBAH
  // =========================================================
  Future<void> addPelanggan({
    required String nama,
    required String nomorHp,
    String? email,
    String? alamat,
    String? jenisKelamin,
  }) async {
    // Validasi nama
    if (nama.isEmpty) {
      CustomDialog.show(
        title: "Nama Kosong",
        message: "Nama pelanggan wajib diisi.",
        type: DialogType.warning,
      );
      return;
    }

    // Validasi nomor HP
    if (nomorHp.isEmpty || nomorHp.length < 8) {
      CustomDialog.show(
        title: "Nomor HP Tidak Valid",
        message: "Nomor HP minimal 8 karakter.",
        type: DialogType.error,
      );
      return;
    }

    // Validasi email opsional
    if (!isValidEmail(email ?? "")) {
      CustomDialog.show(
        title: "Email Tidak Valid",
        message: "Format email tidak benar.",
        type: DialogType.error,
      );
      return;
    }

    try {
      await _service.createPelanggan(
        nama: nama,
        nomorHp: nomorHp,
        email: email,
        alamat: alamat,
        jenisKelamin: jenisKelamin,
      );

      await fetchAllPelanggan();

      CustomDialog.show(
        title: "Berhasil",
        message: "Pelanggan berhasil ditambahkan.",
        type: DialogType.success,
      );

    } catch (e) {
      CustomDialog.show(
        title: "Gagal Menambah",
        message: "Terjadi kesalahan saat menambah pelanggan.",
        type: DialogType.error,
      );
    }
  }

  // =========================================================
  //               UPDATE PELANGGAN
  // =========================================================
  Future<void> updatePelanggan(Pelanggan pelanggan) async {
    try {
      await _service.updatePelanggan(pelanggan);
      await fetchAllPelanggan();

      CustomDialog.show(
        title: "Berhasil",
        message: "Data pelanggan berhasil diperbarui.",
        type: DialogType.success,
      );

    } catch (e) {
      CustomDialog.show(
        title: "Gagal Update",
        message: "Tidak dapat memperbarui data pelanggan.",
        type: DialogType.error,
      );
    }
  }

  // =========================================================
  //               HAPUS PELANGGAN
  // =========================================================
  Future<void> deletePelanggan(int id) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Hapus Pelanggan?"),
        content: const Text("Data pelanggan akan dihapus permanen."),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Batal"),
          ),
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

        CustomDialog.show(
          title: "Berhasil",
          message: "Pelanggan berhasil dihapus.",
          type: DialogType.success,
        );

      } catch (e) {
        CustomDialog.show(
          title: "Gagal Menghapus",
          message: "Tidak dapat menghapus data pelanggan.",
          type: DialogType.error,
        );
      }
    }
  }
}

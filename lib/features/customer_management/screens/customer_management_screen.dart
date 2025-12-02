import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/core/widgets/base_screen.dart';
import 'package:kasir_kosmetic/data/models/pelanggan_model.dart';
import 'package:kasir_kosmetic/features/customer_management/controller/pelanggan_controller.dart';
import 'package:kasir_kosmetic/features/customer_management/widgets/add_edit_customer_bottom_sheet.dart';

class CustomerManagementScreen extends StatelessWidget {
  CustomerManagementScreen({super.key});

  final PelangganController controller = Get.put(PelangganController());

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Manajemen Pelanggan",
      showProfile: true,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Pelanggan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => _showAddEditDialog(null),
                  child: Container(
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.add, color: Colors.black, size: 30),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final customers = controller.pelangganList;

              if (customers.isEmpty) {
                return const Center(child: Text("Belum ada pelanggan"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final c = customers[index];
                  return Container(
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Kolom Kiri: Nama + Jenis Kelamin
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  c.jenisKelamin,
                                  style: TextStyle(
                                    color: Colors.pink[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Kolom Kanan: Total Pembelian + Ikon Edit & Delete
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Total Pembelian (di atas)
                              Text(
                                "${c.totalPembelian} Pembelian",
                                style: const TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Ikon Edit & Delete (sejajar)
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _showAddEditDialog(c),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        controller.deletePelanggan(c.id),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(Pelanggan? pelanggan) {
    Get.dialog(
      AddEditCustomerDialog(
        initialData: pelanggan,
        onSave: (nama, nomorHp, email, alamat, jenisKelamin) {
          if (pelanggan != null) {
            final updated = Pelanggan(
              id: pelanggan.id,
              nama: nama,
              nomorHp: nomorHp,
              email: email,
              alamat: alamat,
              jenisKelamin: jenisKelamin,
              totalPembelian: pelanggan.totalPembelian,
              dibuatPada: pelanggan.dibuatPada,
              diperbaruiPada: DateTime.now(),
            );
            controller.updatePelanggan(updated);
          } else {
            controller.addPelanggan(
              nama: nama,
              nomorHp: nomorHp,
              email: email,
              alamat: alamat,
              jenisKelamin: jenisKelamin,
            );
          }
        },
      ),
    );
  }
}

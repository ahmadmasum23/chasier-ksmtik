import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/core/constants/app_colors.dart';
import 'package:kasir_kosmetic/data/models/pelanggan_model.dart';
import 'package:kasir_kosmetic/features/auth/widgets/custom_dialog.dart';

class AddEditCustomerDialog extends StatefulWidget {
  final Pelanggan? initialData;
  final Function(
    String nama,
    String nomorHp,
    String? email,
    String? alamat,
    String jenisKelamin,
  )
  onSave;

  const AddEditCustomerDialog({
    super.key,
    this.initialData,
    required this.onSave,
  });

  @override
  State<AddEditCustomerDialog> createState() => _AddEditCustomerDialogState();
}

class _AddEditCustomerDialogState extends State<AddEditCustomerDialog> {
  late TextEditingController _namaCtrl;
  late TextEditingController _alamatCtrl;
  late TextEditingController _nomorHpCtrl;
  late TextEditingController _emailCtrl;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.initialData?.nama);
    _alamatCtrl = TextEditingController(text: widget.initialData?.alamat);
    _nomorHpCtrl = TextEditingController(text: widget.initialData?.nomorHp);
    _emailCtrl = TextEditingController(text: widget.initialData?.email);
    _selectedGender = widget.initialData?.jenisKelamin;
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _alamatCtrl.dispose();
    _nomorHpCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final nama = _namaCtrl.text.trim();
    final alamat = _alamatCtrl.text.trim();
    final nomorHp = _nomorHpCtrl.text.trim();
    final email = _emailCtrl.text.trim().isNotEmpty
        ? _emailCtrl.text.trim()
        : null;
    final gender = _selectedGender;

    // VALIDASI WAJIB ISI
    if (nama.isEmpty || nomorHp.isEmpty || gender == null) {
      CustomDialog.show(
        title: "Field Belum Lengkap",
        message: "Nama, Nomor HP, dan Jenis Kelamin wajib diisi!",
        type: DialogType.warning,
      );
      return;
    }

    // VALIDASI EMAIL
    if (email != null) {
      final emailRegex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      );
      if (!emailRegex.hasMatch(email)) {
        CustomDialog.show(
          title: "Email Tidak Valid",
          message: "Masukkan format email yang benar (contoh: nama@gmail.com).",
          type: DialogType.error,
        );
        return;
      }
    }

    // VALIDASI NOMOR HP: hanya angka, panjang minimal 10 maksimal 15
    final hpRegex = RegExp(r'^[0-9]{10,15}$');
    if (!hpRegex.hasMatch(nomorHp)) {
      CustomDialog.show(
        title: "Nomor HP Tidak Valid",
        message: "Nomor HP harus 10–15 digit dan hanya angka.",
        type: DialogType.error,
      );
      return;
    }

    // Jika lolos semua validasi → simpan
    widget.onSave(nama, nomorHp, email, alamat, gender);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? "Edit Pelanggan" : "Tambah Pelanggan",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),

                // Nama
                _buildInputField(controller: _namaCtrl, hint: "Nama Pelanggan"),
                const SizedBox(height: 16),
                // Email
                _buildInputField(
                  controller: _emailCtrl,
                  hint: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Nomor HP
                _buildInputField(
                  controller: _nomorHpCtrl,
                  hint: "Nomor Telepon",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Jenis Kelamin
                _buildGenderDropdown(),
                const SizedBox(height: 16),

                // Alamat
                _buildInputField(
                  controller: _alamatCtrl,
                  hint: "Alamat",
                  maxLines: 2,
                ),
                const SizedBox(height: 54),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.makeupColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      "Simpan",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Tutup (X)
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: "Tutup",
            ),
          ),
        ],
      ),
    );
  }

  // Widget input field seperti di produk
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.makeupColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.makeupColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          hintText: "Jenis Kelamin",
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        items: const [
          DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
          DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
        ],
        onChanged: (value) => setState(() => _selectedGender = value),
        isDense: true,
      ),
    );
  }
}

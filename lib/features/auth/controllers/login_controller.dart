import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/data/services/auth_service.dart';
import 'package:kasir_kosmetic/features/auth/widgets/custom_dialog.dart';
import 'package:kasir_kosmetic/features/dashboard/screens/dashboard_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var rememberMe = false.obs;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  // Validasi email
  bool _isValidEmail(String email) {
    const pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    return RegExp(pattern).hasMatch(email);
  }

  // FUNGSI LOGIN
 Future<void> login() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  //  VALIDASI KHUSUS
  if (email.isNotEmpty && password.isEmpty) {
    CustomDialog.show(
      title: "Password Wajib Diisi",
      message: "Silakan isi password terlebih dahulu.",
      type: DialogType.warning,
    );
    return;
  }

  if (email.isEmpty && password.isNotEmpty) {
    CustomDialog.show(
      title: "Email Wajib Diisi",
      message: "Silakan isi email terlebih dahulu.",
      type: DialogType.warning,
    );
    return;
  }

  //  VALIDASI JIKA DUA-DUANYA KOSONG
  if (email.isEmpty && password.isEmpty) {
    CustomDialog.show(
      title: "Field Tidak Boleh Kosong",
      message: "Silakan isi email dan password.",
      type: DialogType.warning,
    );
    return;
  }

  //  VALIDASI FORMAT EMAIL
  if (!_isValidEmail(email)) {
    CustomDialog.show(
      title: "Email Tidak Valid",
      message: "Masukkan email yang benar.",
      type: DialogType.error,
    );
    return;
  }

  //  MULAI LOADING
  isLoading.value = true;

  final errorMessage = await AuthService().login(email, password);

  //  STOP LOADING
  isLoading.value = false;

  //  LOGIN SUKSES
  if (errorMessage == null) {
    CustomDialog.show(
      title: "Login Berhasil",
      message: "Selamat datang kembali!",
      type: DialogType.success,
    );

    Future.delayed(const Duration(milliseconds: 900), () {
      Get.offAll(() => const DashboardScreen());
    });

    return;
  }

  //  LOGIN GAGAL
  CustomDialog.show(
    title: "Login Gagal",
    message: errorMessage,
    type: DialogType.error,
  );
}


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

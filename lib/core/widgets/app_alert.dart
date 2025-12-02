// lib/core/widgets/app_alert.dart
import 'package:flutter/material.dart';

class AppAlert {
  // ---- Public: named "showX" (used in controller) ----
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      color: Colors.green,
      icon: Icons.check_circle_rounded,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      color: Colors.red,
      icon: Icons.cancel_rounded,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      color: Colors.orange,
      icon: Icons.warning_rounded,
    );
  }

  // ---- Backwards-compatible convenience methods ----
  static void success(BuildContext context, String message, {String title = "Berhasil"}) {
    showSuccess(context: context, title: title, message: message);
  }

  static void error(BuildContext context, String message, {String title = "Gagal"}) {
    showError(context: context, title: title, message: message);
  }

  static void warning(BuildContext context, String message, {String title = "Peringatan"}) {
    showWarning(context: context, title: title, message: message);
  }

  // ---- Internal dialog builder ----
  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 56, color: color),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  ),
                  child: const Text("OK"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

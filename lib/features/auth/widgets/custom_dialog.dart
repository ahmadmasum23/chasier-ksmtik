import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DialogType { success, error, warning }

class CustomDialog {
  static IconData _getIcon(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Icons.check_circle_rounded;
      case DialogType.error:
        return Icons.close_rounded;
      case DialogType.warning:
      default:
        return Icons.warning_rounded;
    }
  }

  static Color _getColor(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      case DialogType.warning:
      default:
        return Colors.amber[700]!;
    }
  }

  static void show({
    required String title,
    required String message,
    required DialogType type,
  }) {
    Get.dialog(
      Center(
        child: AnimatedScale(
          scale: 1,
          duration: const Duration(milliseconds: 200),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            elevation: 12,
            child: Container(
              width: 320,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ICON
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getColor(type).withOpacity(0.15),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      _getIcon(type),
                      color: _getColor(type),
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // TITLE
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getColor(type),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // MESSAGE
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // OK BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

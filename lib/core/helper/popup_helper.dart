import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupHelper {
  static bool _isShowing = false;

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required IconData icon,
  }) {
    if (_isShowing) return;

    _isShowing = true;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 14,
      icon: Icon(icon, color: iconColor, size: 24),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          _isShowing = false;
        }
      },
    );
  }

  static void success(String message, {String title = "Success"}) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFEAF8F0),
      textColor: const Color(0xFF166534),
      iconColor: const Color(0xFF22C55E),
      icon: Icons.check_circle_rounded,
    );
  }

  static void error(String message, {String title = "Error"}) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFFDECEC),
      textColor: const Color(0xFF991B1B),
      iconColor: Color(0xFFD32F2F),
      icon: Icons.cancel_rounded,
    );
  }

  static void outOfStock(String message, {String title = "Out of Stock"}) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFFFF7E6),
      textColor: const Color(0xFF92400E),
      iconColor: const Color(0xFFF59E0B),
      icon: Icons.inventory_2_rounded,
    );
  }
}

import 'package:flutter/material.dart';

class WarningSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = const Color.fromARGB(255, 113, 57, 53),
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}

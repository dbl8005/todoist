import 'package:flutter/material.dart';

Future<void> showInfoDialog(
    {required BuildContext context,
    required String title,
    required String description}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

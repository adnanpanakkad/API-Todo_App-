import 'package:flutter/material.dart';

void showErrorMessage(
  BuildContext context, {
  required String message,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white), // Add text color for better visibility
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessMessage(
  BuildContext context, {
  required String message,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white), // Add text color for better visibility
    ),
    backgroundColor: const Color.fromARGB(255, 54, 244, 70),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

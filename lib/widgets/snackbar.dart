import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message,
    {Color backgroundColor = const Color.fromRGBO(242, 242, 242, 1),
    Color textColor = Colors.black}) {
  final snackbar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: textColor), // Custom text color
    ),
    backgroundColor: backgroundColor, // Custom background color
    behavior:
        SnackBarBehavior.floating, // Allows it to float above other content
    margin: const EdgeInsets.only(top: 50), // Space from top
  );

  // Show snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

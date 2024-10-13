import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? errorText;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.errorText,
    this.suffixIcon,
    this.obscureText = false, // Default is false for normal text fields
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText, // Add this line
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(color: Colors.grey), // Grey label text
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30.0), // Rounded corners when focused
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // General rounded border
        ),
      ),
    );
  }
}

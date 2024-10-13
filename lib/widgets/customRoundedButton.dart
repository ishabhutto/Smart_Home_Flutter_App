import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomRoundedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Round shape
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 30.0), // Button padding
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white, // Text color
          fontSize: 16, // Text size
        ),
      ),
    );
  }
}

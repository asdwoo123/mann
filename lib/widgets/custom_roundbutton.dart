import 'package:flutter/material.dart';
import '../theme.dart';

class CustomRoundButton extends StatelessWidget {
  final double height;
  final String text;
  final void Function() onPressed;

  const CustomRoundButton({
    Key? key,
    this.height = 50,
    required this.text,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

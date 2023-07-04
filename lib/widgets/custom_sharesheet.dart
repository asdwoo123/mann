import 'package:flutter/material.dart';
import 'package:mann/theme.dart';

class CustomShareSheet extends StatelessWidget {
  const CustomShareSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text('Share'),
      style: OutlinedButton.styleFrom(
          primary: primaryBlue,
          fixedSize: Size(90, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: primaryBlue)),
    );
  }
}

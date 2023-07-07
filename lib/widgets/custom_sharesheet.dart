import 'package:flutter/material.dart';
import 'package:mann/theme.dart';

class CustomShareSheet extends StatelessWidget {
  const CustomShareSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        fixedSize: const Size(90, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Share'),
    );
  }
}

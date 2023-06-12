import 'package:flutter/material.dart';

class BrightnessButton extends StatelessWidget {
  const BrightnessButton({
    required this.handleBrightnessChange,
    Key? key
  }) : super(key: key);

  final void Function(bool useLightMode) handleBrightnessChange;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return IconButton(
      icon: isBright
          ? const Icon(Icons.dark_mode_outlined)
          : const Icon(Icons.light_mode_outlined),
      onPressed: () => handleBrightnessChange(!isBright),
    );
  }
}

import 'package:flutter/material.dart';

class CustomSettingItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomSettingItem({
    Key? key,
    required this.label,
    required this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Expanded(flex: 3, child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
                borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none
                )
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12.0),
            suffixIcon: controller.text.isEmpty ? null : IconButton(
              onPressed: () {
                controller.clear();
              }, icon: const Icon(Icons.clear),
            ),
          ),
          controller: controller,
        ))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mann/theme.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final void Function(String?)? onChanged;

  const CustomDropdown(
      {Key? key,
      required this.value,
      required this.items,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: DropdownButton(
          isExpanded: true,
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
                value: item, child: Text(item, overflow: TextOverflow.ellipsis)
            );
          }).toList(),
          onChanged: onChanged,
          underline: const SizedBox(),
        ),
      ),
    );
  }
}

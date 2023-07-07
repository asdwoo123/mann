import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      isExpanded: true,
      iconStyleData: const IconStyleData(
          icon: Row(
            children: [
              Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              SizedBox(width: 16,)
            ],
          ),
        iconSize: 14
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
            value: item, child: Text(item, overflow: TextOverflow.ellipsis)
        );
      }).toList(),
      onChanged: onChanged,
    ));
  }
}

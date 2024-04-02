import 'package:flutter/material.dart';

import 'custom_checkbox.dart';

class CustomCheckboxListTile extends StatelessWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
    // this.titleStyle,
  });

  final String title;
  final bool value;
  // final TextStyle? titleStyle;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 25),
      dense: true,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      leading: CustomCheckbox(
        onChanged: onChanged,
        value: value,
      ),
      title: Text(
        title,
        // textAlign: TextAlign.start,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }
}

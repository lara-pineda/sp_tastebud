import 'package:flutter/material.dart';
import 'custom_checkbox_icon.dart';

class CustomCheckboxListTile extends StatefulWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.initialValue,
    this.onChanged,
  });

  final String title;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void _onChanged(bool? newValue) {
    if (newValue != null) {
      setState(() {
        value = newValue;
        widget.onChanged?.call(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconCheckbox(
          value: value,
          onChanged: (newValue) {
            _onChanged(newValue);
          },
        ),
        Expanded(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class IconCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const IconCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<IconCheckbox> createState() => _IconCheckboxState();
}

class _IconCheckboxState extends State<IconCheckbox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _toggleCheckbox() {
    setState(() {
      _value = !_value;
      if (widget.onChanged != null) {
        widget.onChanged!(_value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: Container(
        child: _value
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.check_rounded,
                  size: 25,
                  color: Colors.red,
                ))
            : Container(
                // Custom dot for unchecked state
                width: 7,
                height: 7,
                // Adjust spacing around the dot
                margin: const EdgeInsets.symmetric(horizontal: 11),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final String? value;
  final List<Widget>? columns;

  const InfoRow({
    super.key,
    this.icon,
    this.label,
    this.value,
    this.columns,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];

    if (icon != null) {
      rowChildren.add(Icon(icon, color: Colors.orange));
      rowChildren.add(SizedBox(width: 8.0));
    }

    if (columns == null) {
      if (label != null) {
        rowChildren.add(
          Expanded(
            flex: 2,
            child: Text(
              label!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
              ),
            ),
          ),
        );
      }
      if (value != null) {
        rowChildren.add(
          Expanded(
            flex: 3,
            child: Text(
              value!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: null,
              textAlign: TextAlign.end,
            ),
          ),
        );
      }
    } else {
      for (var column in columns!) {
        rowChildren.add(Expanded(child: column));
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: rowChildren,
      ),
    );
  }
}

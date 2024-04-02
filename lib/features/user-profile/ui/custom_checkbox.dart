import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Function(bool? p0)? onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return
        // Theme(
        // data: ThemeData(
        //   checkboxTheme: const CheckboxThemeData(
        //     fillColor: MaterialStatePropertyAll<Color?>(
        //       Colors.transparent,
        //     ),
        //     checkColor: MaterialStatePropertyAll<Color?>(
        //       Colors.white,
        //     ),
        //   ),
        // ),
        // child:
        Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.green.shade500,
        borderRadius: BorderRadius.circular(5),
      ),
      // child: Checkbox(
      //   value: value,
      //   onChanged: onChanged,
      // ),
    );
    // );
  }
}

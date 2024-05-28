import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';

class IconCheckbox extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;
  final ValueChanged<bool>? onChanged;
  final String title;
  final String type;
  final int index;

  const IconCheckbox({
    super.key,
    required this.valueNotifier,
    required this.title,
    required this.type,
    required this.onChanged,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            valueNotifier.value = !valueNotifier.value;
            if (onChanged != null) {
              onChanged!(valueNotifier.value);
            }
          },
          child: Container(
            // margin: const EdgeInsets.all(8.0), // Ensure margin is included
            padding: !value
                ? const EdgeInsets.all(11.0)
                : const EdgeInsets.all(2), // Adjust padding if needed
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              color:
                  Colors.transparent, // Make sure the container is transparent
            ),
            child: value
                ? Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                    Icons.check_rounded,
                    size: 25,
                    color: AppColors.redColor,
                  ))
                : Container(
                    // Custom dot for unchecked state
                    width: 8,
                    height: 8,
                    // Adjust spacing around the dot
                    // margin: const EdgeInsets.symmetric(horizontal: 11),
                    decoration: BoxDecoration(
                      color: AppColors.seaGreenColor,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

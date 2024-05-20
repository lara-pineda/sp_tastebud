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
        if (title == 'Keto-friendly') {
          print('$index, $type, $title, $value');
        }
        return GestureDetector(
          onTap: () {
            valueNotifier.value = !valueNotifier.value;
            if (onChanged != null) {
              onChanged!(valueNotifier.value);
            }
          },
          child: Container(
            child: value
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.check_rounded,
                      size: 25,
                      color: AppColors.redColor,
                    ))
                : Container(
                    // Custom dot for unchecked state
                    width: 7,
                    height: 7,
                    // Adjust spacing around the dot
                    margin: const EdgeInsets.symmetric(horizontal: 11),
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

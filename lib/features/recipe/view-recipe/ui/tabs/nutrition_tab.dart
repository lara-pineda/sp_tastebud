import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import '../../model/recipe_model.dart';
import 'info_row.dart';

class NutritionTab extends StatelessWidget {
  final Recipe recipe;

  const NutritionTab({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    int servings = recipe.yield ?? 1; // Default to 1 if not specified

    Map<String, List<String>> nutrientMap = {};

    // Process totalNutrients entries
    for (var entry in recipe.totalNutrients.nutrients.entries) {
      final String unit =
          entry.value.unit == 'Âµg' ? '\u00B5g' : entry.value.unit;
      nutrientMap[entry.value.label] = [
        '${(entry.value.quantity / servings).toStringAsFixed(2)} $unit',
        '',
      ];
    }

    // Process totalDaily entries
    for (var entry in recipe.totalDaily.nutrients.entries) {
      if (nutrientMap.containsKey(entry.value.label)) {
        nutrientMap[entry.value.label]![1] =
            '${(entry.value.quantity / servings).toStringAsFixed(2)}%';
      } else {
        nutrientMap[entry.value.label] = [
          '',
          '${(entry.value.quantity / servings).toStringAsFixed(2)}%',
        ];
      }
    }

    List<Widget> rows = [];

    // Add the header row
    rows.add(
      InfoRow(
        columns: [
          Text(
            'Per Serving',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: AppColors.purpleColor,
            ),
          ),
          Text(
            'Amount',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: AppColors.purpleColor,
            ),
            textAlign: TextAlign.end,
          ),
          Text(
            'RDA',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: AppColors.purpleColor,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );

    // Create rows from nutrientMap
    nutrientMap.forEach((label, values) {
      rows.add(
        InfoRow(
          columns: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: AppColors.purpleColor,
              ),
            ),
            ...values.map((value) => Text(
                  value == '' ? '-' : value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                  textAlign: TextAlign.end,
                )),
          ],
        ),
      );
    });

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nutritional Information',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.purpleColor,
                )),
            SizedBox(height: 20),
            ...rows,
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Percent Daily Values are based on a 2,000 calorie diet. Your Daily Values may be higher or lower depending on your calorie intake.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

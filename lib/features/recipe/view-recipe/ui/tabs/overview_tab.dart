import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import '../../model/recipe_model.dart';
import 'info_row.dart';
import 'package:sp_tastebud/core/utils/capitalize_first_letter.dart';

class OverviewTab extends StatelessWidget {
  final Recipe recipe;

  const OverviewTab({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            InfoRow(
              columns: [
                Text(
                  'Source',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.source,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Servings',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.yield.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Calories',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.calories.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Cuisine Type',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.cuisineType
                      .map((type) {
                        return capitalizeFirstLetters(type);
                      })
                      .toList()
                      .join(', '),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Meal Type',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.mealType
                      .map((type) {
                        return capitalizeFirstLetters(type);
                      })
                      .toList()
                      .join(', '),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Dish Type',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.dishType.isNotEmpty
                      ? recipe.dishType
                          .map((type) {
                            return capitalizeFirstLetters(type);
                          })
                          .toList()
                          .join(', ')
                      : 'N/A',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Tags',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.tags.isNotEmpty ? recipe.tags.join(', ') : 'N/A',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

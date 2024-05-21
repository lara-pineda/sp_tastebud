import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import '../../model/recipe_model.dart';
import 'info_row.dart';

class IngredientsTab extends StatelessWidget {
  final Recipe recipe;
  final Iterable<String> allIngredients;

  const IngredientsTab({
    super.key,
    required this.recipe,
    required this.allIngredients,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  'Note: Texts colored in red mean that the ingredient is missing from your inventory or it does not fit your preferences.',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ),
            ...recipe.ingredients.map((line) {
              bool containsIngredient = allIngredients.any((ingredient) =>
                  line.food.toLowerCase().contains(ingredient.toLowerCase()));

              return InfoRow(
                columns: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "> ",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: AppColors.purpleColor,
                          ),
                        ),
                        TextSpan(
                          text: line.text.replaceAll('Â', ''),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color:
                                containsIngredient ? Colors.black : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/features/user-profile/bloc/user_profile_bloc.dart';
import '../../ingredient_substitution_api.dart';
import '../../model/recipe_model.dart';
import '../../food_database_api.dart';
import '../ingredient_substitutes_dialog.dart';
import 'info_row.dart';

class IngredientsTab extends StatefulWidget {
  final Recipe recipe;
  final Iterable<String> allIngredients;

  const IngredientsTab({
    super.key,
    required this.recipe,
    required this.allIngredients,
  });

  @override
  State<IngredientsTab> createState() => _IngredientsTabState();
}

class _IngredientsTabState extends State<IngredientsTab> {
  late UserProfileBloc _userProfileBloc;
  late List<String> userAllergens;

  @override
  void initState() {
    super.initState();
    _userProfileBloc = GetIt.instance<UserProfileBloc>();
    userAllergens = _userProfileBloc
        .getUserAllergens()
        .split('&health=')
        .where((e) => e.isNotEmpty)
        .toList()
        .map((allergen) => allergenToHealthLabelMap[allergen] ?? allergen)
        .toList();
  }

  Future<List<String>> fetchHealthLabelsOfIngredient(String foodId) async {
    try {
      final response = await FoodDatabaseAPI.getNutritionalInfo(foodId);
      return List<String>.from(response['healthLabels']);
    } catch (e) {
      return [];
    }
  }

  Future<void> _showSubstituteDialog(String ingredient) async {
    final encodedIngredient = ingredient.toLowerCase();
    final substitutes = await IngredientSubstitutionAPI.getIngredientSubstitute(
      query: encodedIngredient,
    );

    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return IngredientSubstitutesDialog(
            substitutes: substitutes?.substitutes ?? [],
            message: substitutes?.message ?? '',
          );
        },
      );
    }
  }

  // Define a mapping between user allergens and health labels
  static const Map<String, String> allergenToHealthLabelMap = {
    'alcohol-free': 'ALCOHOL_FREE',
    'celery-free': 'CELERY_FREE',
    'crustacean-free': 'CRUSTACEAN_FREE',
    'dairy-free': 'DAIRY_FREE',
    'egg-free': 'EGG_FREE',
    'fish-free': 'FISH_FREE',
    'gluten-free': 'GLUTEN_FREE',
    'mollusk-free': 'MOLLUSK_FREE',
    'mustard-free': 'MUSTARD_FREE',
    'peanut-free': 'PEANUT_FREE',
    'pork-free': 'PORK_FREE',
    'red-meat-free': 'RED_MEAT_FREE',
    'soy-free': 'SOY_FREE',
    'wheat-free': 'WHEAT_FREE',
  };

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
                'Note: Texts colored in red mean that the ingredient is missing from your inventory while texts colored in green are identified as allergens according to your user profile.',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            ...widget.recipe.ingredients.map((line) {
              return FutureBuilder<List<String>>(
                future: fetchHealthLabelsOfIngredient(line.foodId),
                builder: (context, snapshot) {
                  bool containsIngredient = widget.allIngredients.any(
                      (ingredient) => line.food
                          .toLowerCase()
                          .contains(ingredient.toLowerCase()));

                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                text: line.text
                                    .replaceAll('Â', '')
                                    .replaceAll('â', '')
                                    .replaceAllMapped(RegExp(r'[^\x20-\x7E]+'),
                                        (match) => '/'),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final healthLabels = snapshot.data ?? [];
                    final missingAllergens = userAllergens
                        .where((allergen) => !healthLabels.contains(allergen))
                        .toList()
                        .map((allergen) =>
                            allergen.toLowerCase().replaceAll("_", "-"));
                    final isAllergen = missingAllergens.isNotEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(
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
                                    text: line.text
                                        .replaceAll('Â', '')
                                        .replaceAll('â', '')
                                        .replaceAllMapped(
                                            RegExp(r'[^\x20-\x7E]+'),
                                            (match) => '/'),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      color: isAllergen
                                          ? Colors.green
                                          : (containsIngredient
                                              ? Colors.black
                                              : Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isAllergen)
                          Padding(
                              padding: EdgeInsets.only(left: 50),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "*The above ingredient is not ${missingAllergens.join(', ')}.",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          color: Colors.black87,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            _showSubstituteDialog(line.food),
                                        child: Text(
                                          "See suggested substitutes",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0,
                                            color: Colors.black87,
                                            fontStyle: FontStyle.italic,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      // Display substitute ingredients here
                                    ],
                                  ))),
                      ],
                    );
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

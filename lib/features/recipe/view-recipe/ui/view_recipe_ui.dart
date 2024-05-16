import 'dart:convert';

import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/core/utils/capitalize_first_letter.dart';
import 'package:sp_tastebud/core/config/assets_path.dart';
import 'package:sp_tastebud/core/utils/load_svg.dart';
import '../../../ingredients/bloc/ingredients_bloc.dart';
import '../bloc/view_recipe_bloc.dart';
import '../model/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'info_row.dart';

class ViewRecipe extends StatefulWidget {
  final String recipeId;

  const ViewRecipe({super.key, required this.recipeId});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final IngredientsBloc _ingredientsBloc = GetIt.instance<IngredientsBloc>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Ensure the bloc is accessed after the widget build process is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BlocProvider.of<ViewRecipeBloc>(context, listen: false)
            .add(FetchRecipe(widget.recipeId));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Ensures the recipe is loaded before building the UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewRecipeBloc, ViewRecipeState>(
      builder: (context, state) {
        if (state is RecipeLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RecipeLoaded) {
          // Get all ingredients from IngredientsBloc
          final allIngredients = _ingredientsBloc.allIngredients
              .map((ingredient) => ingredient.toLowerCase());

          return _buildRecipePage(state.recipe, allIngredients);
        } else if (state is RecipeError) {
          return Text('Error: ${state.error}');
        }
        return Center(child: Text("Recipe Null"));
      },
    );
  }

  Widget _buildRecipePage(
      Map<String, dynamic> recipeData, Iterable<String> ingredients) {
    // Convert the map to a Recipe object right here within the method
    Recipe recipe = Recipe.fromJson(recipeData['recipe']);
    print(ingredients);

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            snap: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.link),
                onPressed: () => _launchURL(recipe.url),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                recipe.label ?? 'No Title',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontFamily: 'Poppins',
                ),
              ),
              background: Image.network(
                recipe.image ?? '',
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Print error to console
                  print('Failed to load image: $error');
                  return Image.asset(
                    Assets.imagePlaceholder, // Use a local fallback image
                  );
                },
              ),
            ),
          ),
        ];
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TabBar(
            controller: _tabController,
            labelStyle: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
            labelColor: AppColors.orangeColor,
            unselectedLabelStyle: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(text: "Overview"),
              Tab(text: "Ingredients"),
              Tab(text: "Nutritional Information"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildOverviewTab(recipe),
                _buildIngredientsTab(recipe, ingredients),
                _buildNutritionTab(recipe),
              ],
            ),
          ),
          SizedBox(height: (20.toVHLength).toPX()),
          Center(
            child: Image.asset(
              Assets.imagesEdamamAttribution,
              width: 250,
              errorBuilder: (context, error, stackTrace) {
                // Print error to console
                print('Failed to load image: $error');
                return Image.asset(
                  Assets.imagePlaceholder, // Use a local fallback image
                );
              },
            ),
          ),
          SizedBox(height: (20.toVHLength).toPX()),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Recipe recipe) {
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
                    fontSize: 16.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.source,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
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
                    fontSize: 16.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.yield.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
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
                    fontSize: 16.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.calories.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
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
                    fontSize: 16.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.cuisineType
                      .map((type) {
                        return capitalizeFirstLetter(type);
                      })
                      .toList()
                      .join(', '),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
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
                    fontSize: 16.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.mealType
                      .map((type) {
                        return capitalizeFirstLetter(type);
                      })
                      .toList()
                      .join(', '),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
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
                    fontSize: 16.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.tags.join(', '),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
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

  Widget _buildIngredientsTab(Recipe recipe, Iterable<String> allIngredients) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recipe.ingredients.map((line) {
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
                        fontSize: 16.0,
                        color: containsIngredient ? Colors.black : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    ));
  }

  Widget _buildNutritionTab(Recipe recipe) {
    int servings = recipe.yield ??
        1; // Get the number of servings, default to 1 if not specified

    Map<String, List<String>> nutrientMap = {};

    // Process totalNutrients entries
    recipe.totalNutrients.nutrients.entries.forEach((entry) {
      final String unit =
          entry.value.unit == 'Âµg' ? '\u00B5g' : entry.value.unit;
      nutrientMap[entry.value.label] = [
        '${(entry.value.quantity / servings).toStringAsFixed(2)} $unit',
        '',
      ];
    });

    // Process totalDaily entries
    recipe.totalDaily.nutrients.entries.forEach((entry) {
      if (nutrientMap.containsKey(entry.value.label)) {
        nutrientMap[entry.value.label]![1] =
            '${(entry.value.quantity / servings).toStringAsFixed(2)}%';
      } else {
        nutrientMap[entry.value.label] = [
          '',
          '${(entry.value.quantity / servings).toStringAsFixed(2)}%',
        ];
      }
    });

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
                    fontSize: 16.0,
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
            SizedBox(height: (20.toVHLength).toPX()),
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

  void _launchURL(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Use Flutter's user interface libraries to show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}

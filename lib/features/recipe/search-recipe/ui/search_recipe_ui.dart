import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import 'package:sp_tastebud/shared/custom_dialog.dart';
import 'package:sp_tastebud/shared/search_bar/custom_search_bar.dart';
import 'package:sp_tastebud/shared/recipe_card/recipe_card.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/recipe_search_api.dart';
import '../../../../core/utils/extract_recipe_id.dart';
import '../../../../shared/checkbox_card/options.dart';
import '../../../user-profile/bloc/user_profile_bloc.dart';
import '../bloc/search_recipe_bloc.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  // used for fetching user details
  List<bool> selectedDietaryPreferences = [];
  List<bool> selectedAllergies = [];
  List<bool> selectedMacronutrients = [];
  List<bool> selectedMicronutrients = [];

  TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Call the recipe search api
  Future<void> _searchRecipes(String recipeId, String healthQuery,
      String macroQuery, String microQuery) async {
    try {
      // print(healthQuery + macroQuery + microQuery);
      var query = healthQuery + macroQuery + microQuery;

      final recipes = await RecipeSearchAPI.searchRecipes(recipeId, query);
      if (recipes.isNotEmpty) {
        setState(() {
          _recipes = recipes;
        });
      } else {
        print("SEARCH RESULTS LIST EMPTY!");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accessing UserProfileBloc using BlocBuilder
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      buildWhen: (previous, current) =>
          current is UserProfileLoaded ||
          current is UserProfileError ||
          current is UserProfileInitial,
      builder: (context, userProfileState) {
        if (userProfileState is UserProfileLoaded) {
          return BlocListener<SearchRecipeBloc, SearchRecipeState>(
            listener: (context, state) {
              if (state is FavoritesError) {
                // Handle error, maybe show a snackbar
                print("Error adding to recipe collection");
              } else if (state is FavoritesAdded) {
                print("Added to recipe collection!");
              }
            },
            child: _buildSearchRecipeUI(userProfileState),
          );
        } else if (userProfileState is UserProfileError) {
          // Show error message if loading fails
          return Center(child: Text(userProfileState.error));
        } else if (userProfileState is UserProfileInitial) {
          return Center(child: Text("Initial"));
        }
        // Fallback widget
        return CircularProgressIndicator();
      },
    );
  }

  String buildHealthTags(List<dynamic> tags) {
    return tags
        .map((tag) =>
            '&health=${tag.toString().toLowerCase().replaceAll(" ", "-")}')
        .join('');
  }

  String mapNutrients(List<dynamic> nutrients, List<String> optionToMap,
      List<String> tagToMap) {
    Map<String, String> tagMapMacro = Map.fromIterables(optionToMap, tagToMap);
    return nutrients
        .map((nutrient) =>
            '&nutrients%5B${tagMapMacro[nutrient.toString()]}%5D=0%2B')
        .join('');
  }

  Widget _buildSearchRecipeUI(UserProfileLoaded state) {
    // print("FETCHED USER PROFILE:");
    // print(state.dietaryPreferences);
    // print(state.allergies);
    // print(state.macronutrients);
    // print(state.micronutrients);

    String healthQuery = buildHealthTags(state.dietaryPreferences) +
        buildHealthTags(state.allergies);
    String macroQuery = mapNutrients(
        state.macronutrients, Options.macronutrients, Options.nutrientTag1);
    String microQuery = mapNutrients(
        state.micronutrients, Options.micronutrients, Options.nutrientTag2);

    return Center(
      child: Column(children: <Widget>[
        // search bar
        CustomSearchBar(
          onSubmitted: (query) =>
              _searchRecipes(query, healthQuery, macroQuery, microQuery),
        ),

        // sample button for dialog
        SizedBox(
          width: (MediaQuery.of(context).size.width / 6) * 4.5,
          child: ElevatedButton(
            onPressed: () {
              openDialog(context, "Sample Title", "Lorem ipsum dolor sit amet");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: '#F06F6F'.toColor(),
              foregroundColor: const Color(0xFFF7EBE8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            child: const Text("Click Me"),
          ),
        ),

        const SizedBox(height: 20),

        // search results
        Expanded(
          child: ListView.builder(
            itemCount: _recipes.length,
            itemBuilder: (context, index) {
              final recipe = _recipes[index];
              return GestureDetector(
                onTap: () {
                  // Get the recipe data as a Map or directly pass the Recipe object if serialized
                  final recipeId = extractRecipeIdUsingRegExp(recipe['uri']);
                  context.goNamed('viewRecipe',
                      pathParameters: {'recipeId': recipeId});
                },
                child: RecipeCard(
                  recipeName: recipe['label'],
                  imageUrl: recipe['images']['THUMBNAIL']['url'],
                  sourceWebsite: recipe['source'],
                  recipeUri: recipe['uri'],
                  bloc: BlocProvider.of<SearchRecipeBloc>(context),
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}

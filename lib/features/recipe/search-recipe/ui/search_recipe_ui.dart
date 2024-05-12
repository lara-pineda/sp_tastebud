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
  Future<void> _searchRecipes(String recipeId) async {
    try {
      final recipes = await RecipeSearchAPI.searchRecipes(recipeId);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // // Helper method to map selected options to boolean values
  // List<bool> mapOptionsToBoolean(
  //     List<dynamic> selectedOptions, List<String> allOptions) {
  //   return allOptions
  //       .map((option) => selectedOptions.contains(option))
  //       .toList();
  // }

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

  Widget _buildSearchRecipeUI(UserProfileLoaded state) {
    // Map the selected options to boolean values
    // selectedDietaryPreferences = mapOptionsToBoolean(
    //     state.dietaryPreferences, Options.dietaryPreferences);
    // selectedAllergies = mapOptionsToBoolean(state.allergies, Options.allergies);
    // selectedMacronutrients =
    //     mapOptionsToBoolean(state.macronutrients, Options.macronutrients);
    // selectedMicronutrients =
    //     mapOptionsToBoolean(state.micronutrients, Options.micronutrients);

    print("FETCHED USER PROFILE:");
    print(state.dietaryPreferences);
    print(state.allergies);
    print(state.macronutrients);
    print(state.micronutrients);

    return Center(
      child: Column(children: <Widget>[
        // search bar
        CustomSearchBar(
          onSubmitted: (query) => _searchRecipes(query),
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

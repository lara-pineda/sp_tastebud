import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import 'package:sp_tastebud/core/widgets/custom_dialog.dart';
import 'package:sp_tastebud/shared/search_bar/custom_search_bar.dart';
import 'package:sp_tastebud/shared/recipe_card/recipe_card.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/recipe_search_api.dart';
import '../bloc/search_recipe_bloc.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Call the recipe search api
  Future<void> _searchRecipes(String query) async {
    try {
      final recipes = await RecipeSearchAPI.searchRecipes(query);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchRecipeBloc, SearchRecipeState>(
        listener: (context, state) {
          if (state is FavoritesError) {
            // Handle error, maybe show a snackbar
            print("Error adding to recipe collection");
          } else if (state is FavoritesAdded) {
            // Handle success, maybe show a snackbar
            print("Added to recipe collection!");
          }
        },
        child: Center(
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
                  openDialog(
                      context, "Sample Title", "Lorem ipsum dolor sit amet");
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
                  return RecipeCard(
                    recipeName: recipe['label'],
                    imageUrl: recipe['images']['THUMBNAIL']['url'],
                    sourceWebsite: recipe['source'],
                    recipeUri: recipe['uri'],
                    bloc: BlocProvider.of<SearchRecipeBloc>(context),
                  );
                },
              ),
            )
          ]),
        ));
  }
}

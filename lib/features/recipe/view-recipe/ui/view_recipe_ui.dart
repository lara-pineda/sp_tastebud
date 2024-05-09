import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import '../../search-recipe/bloc/search_recipe_bloc.dart';
import '../bloc/view_recipe_bloc.dart';
import '../model/recipe_model.dart';
import '../../search-recipe/recipe_search_api.dart';

class ViewRecipe extends StatefulWidget {
  final String recipeId;

  const ViewRecipe({super.key, required this.recipeId});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  // late Map<String, dynamic> decodedJson;

  @override
  // void initState() {
  //   super.initState();
  //
  //   // Trigger the event to fetch the recipe only once when the widget is initialized
  //   Future.microtask(() =>
  //       BlocProvider.of<ViewRecipeBloc>(context, listen: false)
  //           .add(FetchRecipe(widget.recipeId)));
  //   // _searchRecipeById(widget.recipeId);
  // }
  void initState() {
    super.initState();
    // Ensure the bloc is accessed after the widget build process is complete
    Future.microtask(() =>
        BlocProvider.of<ViewRecipeBloc>(context, listen: false)
            .add(FetchRecipe(widget.recipeId)));
  }

  // // Call the recipe search api
  // Future<void> _searchRecipeById(String query) async {
  //   try {
  //     var data = await RecipeSearchAPI.searchRecipeById(query);
  //     setState(() {
  //       decodedJson = data;
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  // Ensures the recipe is loaded before building the UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewRecipeBloc, ViewRecipeState>(
      builder: (context, state) {
        if (state is RecipeLoading) {
          return CircularProgressIndicator();
        } else if (state is RecipeLoaded) {
          return _buildRecipeCard(state.recipe);
        } else if (state is RecipeError) {
          return Text('Error: ${state.error}');
        }
        return Center(child: Text("Recipe Null"));
      },
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    print("herererere");
    print(recipe);

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Text("hereeee")],
          // children: <Widget>[
          //   Image.network(
          //     recipe.imageUrl,
          //     width: double.infinity,
          //     height: 200,
          //     fit: BoxFit.cover,
          //     errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       recipe.label,
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          //   Text('Source: ${recipe.source}'),
          //   Text(
          //       'Servings: ${recipe.yield} | Calories: ${recipe.calories.toStringAsFixed(0)}'),
          //   Divider(),
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children:
          //           recipe.ingredientLines.map((line) => Text(line)).toList(),
          //     ),
          //   ),
          //   Divider(),
          //   Text('Nutritional Information',
          //       style: TextStyle(fontWeight: FontWeight.bold)),
          //   ...recipe.nutrients.map((nutrient) => Text(
          //       '${nutrient.label}: ${nutrient.quantity.toStringAsFixed(2)} ${nutrient.unit}')),
          // ],
        ),
      ),
    );
  }
}

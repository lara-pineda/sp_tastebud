import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import '../../search-recipe/bloc/search_recipe_bloc.dart';
import '../model/recipe_model.dart';

class ViewRecipe extends StatefulWidget {
  // final Recipe recipeJson;
  // final Map<String, dynamic> recipeJson;

  // const ViewRecipe({super.key,required this.recipeJson});
  const ViewRecipe({super.key});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  late Recipe recipe;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   recipe = widget.recipeJson;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchRecipeBloc, SearchRecipeState>(
      builder: (context, state) {
        if (state is RecipeDetailState) {
          return _buildRecipeCard(state.recipe);
        } else if (state is FavoritesLoading) {
          return CircularProgressIndicator();
        } else {
          // This could also be an error state or another appropriate UI for empty/unexpected states
          return Center(child: Text("No recipe selected"));
        }
      },
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    print(recipe);

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            Text("HEREEEE"),
          ],
          // crossAxisAlignment: CrossAxisAlignment.start,
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

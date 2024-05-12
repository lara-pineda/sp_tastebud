import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/view_recipe_bloc.dart';
import '../model/recipe_model.dart';

class ViewRecipe extends StatefulWidget {
  final String recipeId;

  const ViewRecipe({super.key, required this.recipeId});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  @override
  void initState() {
    super.initState();
    // Ensure the bloc is accessed after the widget build process is complete
    Future.microtask(() =>
        BlocProvider.of<ViewRecipeBloc>(context, listen: false)
            .add(FetchRecipe(widget.recipeId)));
  }

  // Ensures the recipe is loaded before building the UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewRecipeBloc, ViewRecipeState>(
      builder: (context, state) {
        if (state is RecipeLoading) {
          return CircularProgressIndicator();
        } else if (state is RecipeLoaded) {
          return _buildRecipeCard(state.recipe);
          // List<Map<String, dynamic>> jsonData = [state.recipe]; // Your JSON data
          // List<Recipe> recipes = jsonData.map((map) => Recipe.fromJson(map)).toList();

          // return _buildRecipeCard(recipes);
        } else if (state is RecipeError) {
          return Text('Error: ${state.error}');
        }
        return Center(child: Text("Recipe Null"));
      },
    );
  }

  void printRecipeDetails(Recipe recipe) {
    print('Cuisine Type: ${recipe.cuisineType.join(', ')}');
    print('Meal Type: ${recipe.mealType.join(', ')}');
    print('Tags: ${recipe.tags.join(', ')}');

    print('Total Nutrients:');
    recipe.totalNutrients.nutrients.forEach((key, nutrient) {
      print('${nutrient.label}: ${nutrient.quantity} ${nutrient.unit}');
    });

    print('Total Daily:');
    recipe.totalDaily.nutrients.forEach((key, nutrient) {
      print('${nutrient.label}: ${nutrient.quantity}% of daily needs');
    });

    print('Digest:');
    recipe.digest.forEach((digest) {
      print('${digest.label}: ${digest.total}${digest.unit}');
    });
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipeData) {
    // Convert the map to a Recipe object
    Recipe recipe = Recipe.fromJson(recipeData);

    return Container(
      margin: EdgeInsets.all(25),
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              recipe.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                recipe.label,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Source: ${recipe.source}'),
            Text(
                'Servings: ${recipe.yield} | Calories: ${recipe.calories.toStringAsFixed(0)}'),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    recipe.ingredientLines.map((line) => Text(line)).toList(),
              ),
            ),
            Divider(),
            Text('Nutritional Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...recipe.digest.map((digest) => Text(
                '${digest.label}: ${digest.total.toStringAsFixed(2)} ${digest.unit}')),
          ],
        ),
      ),
    );
  }
}

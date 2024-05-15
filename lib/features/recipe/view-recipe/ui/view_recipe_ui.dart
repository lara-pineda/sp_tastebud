import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/assets_path.dart';
import '../bloc/view_recipe_bloc.dart';
import '../model/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewRecipe extends StatefulWidget {
  final String recipeId;

  const ViewRecipe({super.key, required this.recipeId});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Ensure the bloc is accessed after the widget build process is complete
    Future.microtask(() =>
        BlocProvider.of<ViewRecipeBloc>(context, listen: false)
            .add(FetchRecipe(widget.recipeId)));
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
          return _buildRecipePage(state.recipe);
        } else if (state is RecipeError) {
          return Text('Error: ${state.error}');
        }
        return Center(child: Text("Recipe Null"));
      },
    );
  }

  Widget _buildRecipePage(Map<String, dynamic> recipeData) {
    // print(recipeData);
    // Convert the map to a Recipe object right here within the method
    Recipe recipe = Recipe.fromJson(recipeData['recipe']);

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
              title: Text(recipe.label ?? 'No Title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              background: Image.network(
                recipe.image ?? '',
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Print error to console
                  print('Failed to load image: $error');
                  return Image.asset(
                    Assets.imagePlaceholder, // Use a local fallback image
                    // width: 100,
                    // height: 100,
                  );
                },
              ),
            ),
          ),
        ];
      },
      body: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
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
                _buildIngredientsTab(recipe),
                _buildNutritionTab(recipe),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Recipe recipe) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Source: ${recipe.source ?? 'Unknown'}'),
          Text(
              'Servings: ${recipe.yield?.toString() ?? 'N/A'} | Calories: ${recipe.calories?.toStringAsFixed(0) ?? 'N/A'}'),
          Text(
              'Cuisine Type: ${recipe.cuisineType.join(', ')} | Meal Type: ${recipe.mealType.join(', ')}'),
          Text('Tags: ${recipe.tags.join(', ')}'),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab(Recipe recipe) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recipe.ingredientLines.map((line) => Text(line)).toList(),
      ),
    );
  }

  Widget _buildNutritionTab(Recipe recipe) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nutritional Information',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...recipe.totalNutrients.nutrients.entries.map((entry) => Text(
              '${entry.value.label}: ${entry.value.quantity} ${entry.value.unit}')),
          ...recipe.totalDaily.nutrients.entries.map((entry) => Text(
              '${entry.value.label}: ${entry.value.quantity}% of daily needs')),
          ...recipe.digest.map((digest) => Text(
              '${digest.label}: ${digest.total.toStringAsFixed(2)} ${digest.unit}')),
        ],
      ),
    );
  }

  void _launchURL(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

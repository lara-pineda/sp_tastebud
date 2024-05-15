import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/shared/recipe_card/recipe_card.dart';
import 'package:sp_tastebud/core/utils/extract_recipe_id.dart';
import '../../../core/themes/app_palette.dart';
import '../../recipe/search-recipe/bloc/search_recipe_bloc.dart';
import '../bloc/recipe_collection_bloc.dart';

class ViewCollectionPage extends StatefulWidget {
  final String collectionType; // 'Saved' or 'Rejected'

  const ViewCollectionPage({super.key, required this.collectionType});

  @override
  State<ViewCollectionPage> createState() => _ViewCollectionPageState();
}

class _ViewCollectionPageState extends State<ViewCollectionPage> {
  late RecipeCollectionBloc _recipeCollectionBloc;
  late SearchRecipeBloc _searchRecipeBloc;

  @override
  void initState() {
    super.initState();
    print('init state!!');
    _recipeCollectionBloc = GetIt.instance<RecipeCollectionBloc>();
    _searchRecipeBloc = GetIt.instance<SearchRecipeBloc>();
    _fetchRecipes();
  }

  void _fetchRecipes() {
    // Dispatch FetchSavedRecipes or FetchRejectedRecipes event based on collectionType
    if (!_recipeCollectionBloc.isClosed) {
      if (widget.collectionType.toLowerCase() == 'saved') {
        print('Fetching saved recipes...');
        _recipeCollectionBloc.add(FetchSavedRecipes());
      } else if (widget.collectionType.toLowerCase() == 'rejected') {
        print('Fetching rejected recipes...');
        _recipeCollectionBloc.add(FetchRejectedRecipes());
      }
    }
  }

  // telling search recipe bloc to update its state
  void _handleRemoveFromFavorites(String recipeUri) {
    _searchRecipeBloc.add(UpdateRecipeFavorites(recipeUri, false));
    _fetchRecipes(); // Refetch recipes when a favorite is removed
  }

  @override
  Widget build(BuildContext context) {
    print('inside view collection page');

    return BlocListener<SearchRecipeBloc, SearchRecipeState>(
      listener: (context, state) {
        if (state is FavoritesRemoved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Removed from recipe collection!")),
          );
        } else if (state is RejectedRemoved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Removed from rejected recipes!")),
          );
        }
      },
      child: BlocBuilder<RecipeCollectionBloc, RecipeCollectionState>(
        builder: (context, state) {
          if (state is RecipeCollectionLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SavedRecipesLoaded ||
              state is RejectedRecipesLoaded) {
            final recipes = state is SavedRecipesLoaded
                ? state.savedRecipes
                : (state as RejectedRecipesLoaded).rejectedRecipes;
            return _buildCollectionPage(widget.collectionType, recipes);
          } else if (state is RecipeCollectionError) {
            return Center(child: Text(state.error));
          } else if (state is RecipeCollectionInitial) {
            return Center(child: Text('Initial'));
          } else {
            print('last statement');
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildCollectionPage(String collectionType, List<dynamic> recipes) {
    print('inside build collection page');
    print(recipes);

    return Column(
      children: [
        SizedBox(height: (50.toVHLength).toPX()),
        Text(
          '$collectionType' == 'saved' ? 'Saved Recipes' : 'Rejected Recipes',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.purpleColor),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: (20.toVHLength).toPX()),
        // Recipe list
        Expanded(
          child: ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  print("Recipe tapped: ${recipe['recipeName']}");
                  final recipeId =
                      extractRecipeIdUsingRegExp(recipe['recipeUri']);
                  context.goNamed('viewRecipeFromCollection', pathParameters: {
                    'collectionType': collectionType,
                    'recipeId': recipeId
                  });
                },
                child: RecipeCard(
                  recipeName: recipe['recipeName']!,
                  imageUrl: recipe['image']!,
                  sourceWebsite: recipe['source']!,
                  recipeUri: recipe['recipeUri'],
                  onRemoveFromFavorites: () =>
                      _handleRemoveFromFavorites(recipe['recipeUri']),
                ),
              );
            },
          ),
        ),
        SizedBox(height: (40.toVHLength).toPX()),
      ],
    );
  }
}

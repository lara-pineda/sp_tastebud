import 'dart:async';

import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/shared/recipe_card/bloc/recipe_bloc.dart';
import 'package:sp_tastebud/shared/recipe_card/ui/recipe_card_collection.dart';
import 'package:sp_tastebud/core/utils/extract_recipe_id.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/core/config/assets_path.dart';
import '../bloc/recipe_collection_bloc.dart';

class ViewCollectionPage extends StatefulWidget {
  final String collectionType; // 'Saved' or 'Rejected'

  const ViewCollectionPage({super.key, required this.collectionType});

  @override
  State<ViewCollectionPage> createState() => _ViewCollectionPageState();
}

class _ViewCollectionPageState extends State<ViewCollectionPage> {
  late final RecipeCollectionBloc _recipeCollectionBloc =
      GetIt.instance<RecipeCollectionBloc>();
  late final RecipeCardBloc _recipeCardBloc = GetIt.instance<RecipeCardBloc>();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _debounceFetchRecipes();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _debounceFetchRecipes() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchRecipes();
    });
  }

  void _fetchRecipes() {
    // Dispatch FetchSavedRecipes or FetchRejectedRecipes event based on collectionType
    if (!_recipeCollectionBloc.isClosed) {
      if (widget.collectionType.toLowerCase() == 'saved') {
        _recipeCollectionBloc.add(FetchSavedRecipes());
      } else if (widget.collectionType.toLowerCase() == 'rejected') {
        _recipeCollectionBloc.add(FetchRejectedRecipes());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCollectionBloc, RecipeCollectionState>(
      builder: (context, state) {
        if (state is RecipeCollectionLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SavedRecipesLoaded ||
            state is RejectedRecipesLoaded) {
          final recipes = state is SavedRecipesLoaded
              ? state.savedRecipes
              : (state as RejectedRecipesLoaded).rejectedRecipes;

          return BlocBuilder<RecipeCardBloc, RecipeCardState>(
            bloc: _recipeCardBloc,
            builder: (context, cardState) {
              if (cardState is RecipeCardUpdated) {
                return _buildCollectionPage(
                    widget.collectionType, recipes, cardState);
              } else {
                return Container();
              }
            },
          );
        } else if (state is RecipeCollectionError) {
          return Center(child: Text(state.error));
        } else if (state is RecipeCollectionInitial) {
          return Center(child: Text('Initial'));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildCollectionPage(
      String collectionType, List<dynamic> recipes, RecipeCardState state) {
    return Column(
      children: [
        SizedBox(height: (50.toVHLength).toPX()),
        Text(
          collectionType == 'saved' ? 'Saved Recipes' : 'Rejected Recipes',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.purpleColor,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: (20.toVHLength).toPX()),
        // Recipe list or empty image
        Expanded(
          child: recipes.isEmpty
              ? Center(
                  child: Image.asset(Assets.emptyCollection),
                )
              : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return GestureDetector(
                      onTap: () {
                        final recipeId =
                            extractRecipeIdUsingRegExp(recipe['recipeUri']);
                        context.goNamed('viewRecipeFromCollection',
                            pathParameters: {
                              'collectionType': collectionType,
                              'recipeId': recipeId,
                            });
                      },
                      child: RecipeCardCollection(
                        recipeName: recipe['recipeName']!,
                        imageUrl: recipe['image']!,
                        sourceWebsite: recipe['source']!,
                        recipeUri: recipe['recipeUri'],
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

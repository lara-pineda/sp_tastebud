import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/bloc/search_recipe_bloc.dart';
import 'package:sp_tastebud/core/utils/extract_recipe_id.dart';

class RecipeCard extends StatefulWidget {
  final String recipeName;
  final String imageUrl;
  final String sourceWebsite;
  final String recipeUri;
  final SearchRecipeBloc bloc;

  const RecipeCard({
    super.key,
    required this.recipeName,
    required this.imageUrl,
    required this.sourceWebsite,
    required this.recipeUri,
    required this.bloc,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  // State to track if recipe is in recipe collection
  bool isInFavorites = false;

  @override
  Widget build(BuildContext context) {
    // print("in recipe card");
    // print(widget.recipeName);
    // print(widget.imageUrl);
    // print(widget.sourceWebsite);
    // print(widget.recipeUri);

    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      // Actual Recipe Contents
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(widget.imageUrl, fit: BoxFit.cover),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        widget.recipeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Source: ',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: widget.sourceWebsite,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          // Add to favorites Icon
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              // Handle click action for adding to favorites
              onTap: () {
                setState(() {
                  isInFavorites = !isInFavorites; // Toggle favorite state
                });
                if (isInFavorites) {
                  context.read<SearchRecipeBloc>().add(AddToFavorites(
                      widget.recipeName,
                      widget.imageUrl,
                      widget.sourceWebsite,
                      extractRecipeIdUsingRegExp(widget.recipeUri)));
                }
                // Optionally handle removing from favorites
              },
              child: Icon(
                isInFavorites ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      // navigate to /my-path, pass 2 arguments to context.state.extra
      // context.push("/view", extra: {"recipeJson": recipe});
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/bloc/search_recipe_bloc.dart';
import 'package:sp_tastebud/core/utils/extract_recipe_id.dart';

import '../../core/config/assets_path.dart';
import '../../features/recipe-collection/data/recipe_collection_repository.dart';
import '../custom_dialog.dart';

class RecipeCard extends StatefulWidget {
  final String recipeName;
  final String imageUrl;
  final String sourceWebsite;
  final String recipeUri;
  final VoidCallback? onRemoveFromFavorites;

  const RecipeCard({
    super.key,
    required this.recipeName,
    required this.imageUrl,
    required this.sourceWebsite,
    required this.recipeUri,
    this.onRemoveFromFavorites,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  // State to track if recipe is in recipe collection
  bool isInFavorites = false;
  bool isInRejected = false;

  @override
  void initState() {
    super.initState();
    _checkIfInFavorites();
    _checkIfInRejected();
  }

  Future<void> _checkIfInFavorites() async {
    final recipeId = extractRecipeIdUsingRegExp(widget.recipeUri);
    final recipeCollectionRepository =
        GetIt.instance<RecipeCollectionRepository>();
    final isFavorite =
        await recipeCollectionRepository.isRecipeInFavorites(recipeId);
    if (mounted) {
      setState(() {
        isInFavorites = isFavorite;
      });
    }
  }

  Future<void> _checkIfInRejected() async {
    // Check if the recipe is in rejected collection similar to favorites
    final recipeId = extractRecipeIdUsingRegExp(widget.recipeUri);
    final recipeCollectionRepository =
        GetIt.instance<RecipeCollectionRepository>();
    final isRejected =
        await recipeCollectionRepository.isRecipeInRejected(recipeId);
    if (mounted) {
      setState(() {
        isInRejected = isRejected;
      });
    }
  }

  void _handleFavoriteToggle(BuildContext context) {
    final action = isInFavorites
        ? 'remove the selected item from'
        : 'add the selected item to';
    final confirmationMessage =
        'Are you sure you want to $action your saved recipes collection?';

    openDialog(
      context,
      'Confirmation',
      confirmationMessage,
      onConfirm: () {
        setState(() {
          isInFavorites = !isInFavorites; // Toggle favorite state
        });
        if (isInFavorites) {
          context.read<SearchRecipeBloc>().add(AddToFavorites(
              widget.recipeName,
              widget.imageUrl,
              widget.sourceWebsite,
              extractRecipeIdUsingRegExp(widget.recipeUri),
              widget.recipeUri));
        } else {
          print('not in favorites');
          if (widget.onRemoveFromFavorites != null) {
            widget.onRemoveFromFavorites!();
          }
          // Ensure RemoveFromFavorites is called immediately after removal
          context.read<SearchRecipeBloc>().add(RemoveFromFavorites(
              extractRecipeIdUsingRegExp(widget.recipeUri)));
        }
      },
    );
  }

  void _handleRejectToggle(BuildContext context) {
    final action = isInRejected ? 'remove from' : 'add to';
    final confirmationMessage =
        'Are you sure you want to $action your rejected recipes collection?';

    openDialog(
      context,
      'Confirmation',
      confirmationMessage,
      onConfirm: () {
        setState(() {
          isInRejected = !isInRejected;
        });
        if (isInRejected) {
          context.read<SearchRecipeBloc>().add(AddToRejected(
              widget.recipeName,
              widget.imageUrl,
              widget.sourceWebsite,
              extractRecipeIdUsingRegExp(widget.recipeUri),
              widget.recipeUri));
        } else {
          context.read<SearchRecipeBloc>().add(
              RemoveFromRejected(extractRecipeIdUsingRegExp(widget.recipeUri)));
        }
      },
    );
  }

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
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8.0),
              //   child: Image.network(widget.imageUrl, fit: BoxFit.cover),
              // ),
              // Load the image and handle errors gracefully
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  // width: 100,
                  // height: 100,
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
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _handleFavoriteToggle(context),
                  child: Icon(
                    isInFavorites ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                SizedBox(width: 8), // Spacing between icons
                GestureDetector(
                  onTap: () => _handleRejectToggle(context),
                  child: Icon(
                    isInRejected
                        ? Icons.remove_circle
                        : Icons.remove_circle_outline,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

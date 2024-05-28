import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';

class IconCheckbox extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;
  final ValueChanged<bool>? onChanged;
  final String title;
  final String type;
  final int index;

  const IconCheckbox({
    super.key,
    required this.valueNotifier,
    required this.title,
    required this.type,
    required this.onChanged,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            valueNotifier.value = !valueNotifier.value;
            if (onChanged != null) {
              onChanged!(valueNotifier.value);
            }
          },
          child: Container(
            // margin: const EdgeInsets.all(8.0), // Ensure margin is included
            padding: !value
                ? const EdgeInsets.all(11.0)
                : const EdgeInsets.all(2), // Adjust padding if needed
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              color:
              Colors.transparent, // Make sure the container is transparent
            ),
            child: value
                ? Container(
              // margin: const EdgeInsets.symmetric(horizontal: 3),
                child: Icon(
                  Icons.check_rounded,
                  size: 25,
                  color: AppColors.redColor,
                ))
                : Container(
              // Custom dot for unchecked state
              width: 8,
              height: 8,
              // Adjust spacing around the dot
              // margin: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: AppColors.seaGreenColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}




import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'custom_checkbox_icon.dart';

class CustomCheckboxListTile extends StatefulWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.valueNotifier,
    this.infoText,
    this.onChanged,
    required this.type,
    required this.index,
  });

  final String title;
  final ValueNotifier<bool> valueNotifier;
  final String? infoText;
  final ValueChanged<bool>? onChanged;
  final String type;
  final int index;

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  void _onChanged(bool? newValue) {
    if (newValue != null) {
      widget.valueNotifier.value = newValue;
      widget.onChanged?.call(newValue);
    }
  }

  void _showInfoDialog(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        title: Text(widget.title,
            style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        content: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLabelTap() {
    // _onChanged(!widget.valueNotifier.value);
    if (widget.infoText != null) {
      _showInfoDialog(widget.infoText!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onChanged(!widget.valueNotifier.value);
      },
      child: Container(
        child: Row(
          children: [
            IconCheckbox(
              valueNotifier: widget.valueNotifier,
              title: widget.title,
              type: widget.type,
              index: widget.index,
              onChanged: _onChanged,
            ),
            Expanded(
              child: GestureDetector(
                onTap: _handleLabelTap,
                child: widget.infoText != null
                    ? RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: widget.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Inter',
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontSize: 16, color: AppColors.redColor))
                  ]),
                )
                    : Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




import 'dart:async';
import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/shared/connectivity/connectivity_listener_widget.dart';
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
    return ConnectivityListenerWidget(
        child: BlocBuilder<RecipeCollectionBloc, RecipeCollectionState>(
          bloc: _recipeCollectionBloc,
          builder: (context, state) {
            if (state is RecipeCollectionLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SavedRecipesLoaded &&
                widget.collectionType.toLowerCase() == 'saved' ||
                state is RejectedRecipesLoaded &&
                    widget.collectionType.toLowerCase() == 'rejected') {
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
            } else {
              return Container();
            }
          },
        ));
  }

  Widget _buildCollectionPage(
      String collectionType, List<dynamic> recipes, RecipeCardState state) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 6,
            floating: false,
            pinned: true,
            leading: Container(
              margin: EdgeInsets.only(left: 5, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                var titleAlignment = top <= kToolbarHeight * 1.8
                    ? Alignment.center
                    : Alignment.bottomLeft;

                return Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: 15, left: 25.0, bottom: 16.0),
                  alignment: titleAlignment,
                  child: Text(
                    collectionType == 'saved'
                        ? 'Saved Recipes'
                        : 'Rejected Recipes',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purpleColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ];
      },
      body: Column(
        children: [
          SizedBox(height: (20.toVHLength).toPX()),
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
        ],
      ),
    );
  }
}

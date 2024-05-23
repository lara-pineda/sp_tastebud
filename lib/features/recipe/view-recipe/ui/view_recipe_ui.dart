import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/shared/connectivity/connectivity_listener_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/core/config/assets_path.dart';
import 'package:sp_tastebud/features/ingredients/bloc/ingredients_bloc.dart';
import 'package:sp_tastebud/shared/recipe_card/bloc/recipe_bloc.dart';
import 'package:sp_tastebud/shared/custom_dialog/custom_dialog.dart';
import '../bloc/view_recipe_bloc.dart';
import '../model/recipe_model.dart';
import 'tabs/overview_tab.dart';
import 'tabs/ingredients_tab.dart';
import 'tabs/nutrition_tab.dart';

class ViewRecipe extends StatefulWidget {
  final String recipeId;
  const ViewRecipe({super.key, required this.recipeId});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final ViewRecipeBloc _viewRecipeBloc = GetIt.instance<ViewRecipeBloc>();
  final IngredientsBloc _ingredientsBloc = GetIt.instance<IngredientsBloc>();
  final RecipeCardBloc _recipeCardBloc = GetIt.instance<RecipeCardBloc>();
  List<String> _allIngredients = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Ensure the bloc is accessed after the widget build process is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _viewRecipeBloc.add(FetchRecipe(widget.recipeId));
        _recipeCardBloc.add(LoadInitialData());
      }
    });

    // Add this listener to detect changes in the RecipeCardBloc state
    _recipeCardBloc.stream.listen((state) {
      if (state is RecipeCardUpdated && mounted) {
        // Check if mounted
        setState(() {
          // No need to update any specific variable since
          // we just need to trigger a rebuild of the UI
        });
      }
    });

    _ingredientsBloc.stream.listen((state) {
      if (state is IngredientsLoaded || state is IngredientsUpdated) {
        _getAllIngredients();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Get all ingredients from IngredientsBloc
  void _getAllIngredients() {
    _allIngredients = _ingredientsBloc.allIngredients;
  }

  void _handleActionConfirmation(BuildContext context, String collectionType,
      bool isInCollection, VoidCallback onConfirm) {
    final type = collectionType == 'favorite' ? 'saved' : 'rejected';
    final action = isInCollection == false ? 'add' : 'remove';
    final confirmationMessage =
        'Are you sure you want to $action this recipe from your $type recipe collection?';

    openDialog(
      context,
      'Confirmation',
      confirmationMessage,
      onConfirm: onConfirm,
      showCancelButton: true,
    );
  }

  // Ensures the recipe is loaded before building the UI
  @override
  Widget build(BuildContext context) {
    return ConnectivityListenerWidget(
        child: BlocBuilder<ViewRecipeBloc, ViewRecipeState>(
      bloc: _viewRecipeBloc,
      builder: (context, state) {
        if (state is RecipeLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RecipeLoaded) {
          _getAllIngredients();
          // Get all ingredients from IngredientsBloc
          final allIngredients =
              _allIngredients.map((ingredient) => ingredient.toLowerCase());

          return _buildRecipePage(state.recipe, allIngredients);
        } else if (state is RecipeError) {
          return Text('Error: ${state.error}');
        }
        return Center(child: Text("Recipe Null"));
      },
    ));
  }

  void _launchURL(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Check if the widget is still mounted
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url. Please try again.')),
        );
      }
    }
  }

  Widget _buildRecipePage(
    Map<String, dynamic> recipeData,
    Iterable<String> ingredients,
  ) {
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
              // arrowback icon
              leading: Container(
                margin: EdgeInsets.only(left: 5, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
              // webview icon
              actions: [
                Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.link),
                      onPressed: () => _launchURL(recipe.url),
                    ))
              ],
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Calculate opacity based on scroll
                  var top = constraints.biggest.height;
                  double visibleMainHeight =
                      top - MediaQuery.of(context).padding.top;
                  double opacity = (visibleMainHeight - kToolbarHeight) /
                      (200 - kToolbarHeight);
                  opacity = opacity.clamp(
                      0.0, 1.0); // Ensure opacity is between 0 and 1

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        recipe.image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback image if there is an error loading the network image
                          return Image.asset(
                            Assets
                                .imagePlaceholder, // Use a local fallback image
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Opacity(
                          opacity: opacity, // Use calculated opacity
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: const [
                                  Colors.transparent,
                                  Colors.black54
                                ],
                              ),
                            ),
                            child: Text(
                              recipe.label ?? 'No Title',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ];
        },
        body: BlocBuilder<RecipeCardBloc, RecipeCardState>(
          bloc: _recipeCardBloc,
          builder: (context, state) {
            bool isInFavorites = false;
            bool isInRejected = false;

            if (state is RecipeCardUpdated) {
              isInFavorites = state.favorites.contains(widget.recipeId);
              isInRejected = state.rejected.contains(widget.recipeId);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: (8.toVHLength).toPX()),

                // add to/remove from collection buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!isInRejected)
                      ElevatedButton(
                        onPressed: () {
                          _handleActionConfirmation(
                              context, 'favorite', isInFavorites, () {
                            _recipeCardBloc.add(ToggleFavorite(
                              recipeName: recipe.label ?? 'No Title',
                              imageUrl: recipe.images['THUMBNAIL']?.url ?? '',
                              sourceWebsite: recipe.source,
                              recipeUri: recipe.uri,
                            ));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangeDisabledColor,
                          foregroundColor: AppColors.orangeDarkerColor,
                        ),
                        child: Row(
                          children: [
                            Icon(isInFavorites
                                ? Icons.favorite
                                : Icons.favorite_border),
                            SizedBox(width: (10.toVWLength).toPX()),
                            Text(isInFavorites
                                ? 'Remove from Saved Recipes'
                                : 'Save Recipe'),
                          ],
                        ),
                      ),
                    if (!isInFavorites)
                      ElevatedButton(
                        onPressed: () {
                          _handleActionConfirmation(
                              context, 'favorite', isInFavorites, () {
                            // add/remove from rejected
                            _recipeCardBloc.add(ToggleReject(
                              recipeName: recipe.label ?? 'No Title',
                              imageUrl: recipe.images['THUMBNAIL']?.url ?? '',
                              sourceWebsite: recipe.source,
                              recipeUri: recipe.uri,
                            ));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grayColor,
                          foregroundColor: Colors.black45,
                        ),
                        child: Row(
                          children: [
                            Icon(isInRejected
                                ? Icons.remove_circle
                                : Icons.remove_circle_outline),
                            SizedBox(width: (10.toVWLength).toPX()),
                            Text(isInRejected
                                ? 'Remove from Rejected Recipes'
                                : 'Reject Recipe'),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: (8.toVHLength).toPX()),

                // tab headers
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.seaGreenColor,
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                  labelColor: AppColors.seaGreenColor,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  tabs: const [
                    Tab(text: "Overview"),
                    Tab(text: "Ingredients"),
                    Tab(text: "Nutrition"),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    // contents of each tab
                    children: <Widget>[
                      // overview tab
                      OverviewTab(recipe: recipe),

                      // ingredients tab
                      // using bloc builder to reflect changes in ingredients real-time
                      BlocBuilder<IngredientsBloc, IngredientsState>(
                        bloc: _ingredientsBloc,
                        builder: (context, ingredientsState) {
                          if (ingredientsState is IngredientsLoaded ||
                              ingredientsState is IngredientsUpdated) {
                            final allIngredients = _ingredientsBloc
                                .allIngredients
                                .map((ingredient) => ingredient.toLowerCase());
                            return IngredientsTab(
                              recipe: recipe,
                              allIngredients: allIngredients,
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),

                      // nutrition tab
                      NutritionTab(recipe: recipe),
                    ],
                  ),
                ),

                SizedBox(height: (20.toVHLength).toPX()),

                // edamam icon
                Center(
                  child: Image.asset(
                    Assets.imagesEdamamAttribution,
                    width: 250,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Assets.imagePlaceholder, // Use a local fallback image
                      );
                    },
                  ),
                ),
                SizedBox(height: (20.toVHLength).toPX()),
              ],
            );
          },
        ));
  }
}

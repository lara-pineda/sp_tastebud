import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/shared/search_bar/custom_search_bar.dart';
import 'package:sp_tastebud/shared/recipe_card/recipe_card.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/recipe_search_api.dart';
import 'package:sp_tastebud/core/config/service_locator.dart';
import 'package:sp_tastebud/core/utils/extract_recipe_id.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';
import 'package:sp_tastebud/core/config/assets_path.dart';
import 'package:sp_tastebud/features/user-profile/bloc/user_profile_bloc.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import '../bloc/search_recipe_bloc.dart';
import 'dart:async';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  List<bool> selectedDietaryPreferences = [];
  List<bool> selectedAllergies = [];
  List<bool> selectedMacronutrients = [];
  List<bool> selectedMicronutrients = [];

  String _healthQuery = '';
  String _macroQuery = '';
  String _microQuery = '';

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _recipes = [];
  bool _isLoading = false;
  bool _initialLoadComplete = false;
  String? _nextUrl;
  String _searchKey = '';

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfileBloc = getIt<UserProfileBloc>();
      if (userProfileBloc.state is UserProfileLoaded) {
        _initializeQueriesAndLoadRecipes(
            userProfileBloc.state as UserProfileLoaded);
        _loadMoreRecipes('');
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchKey = _searchController.text;
        _recipes.clear();
        _nextUrl = null;
        _loadMoreRecipes(_searchKey);
      });
    });
  }

  void _initializeQueriesAndLoadRecipes(UserProfileLoaded state) {
    _healthQuery = buildHealthTags(state.dietaryPreferences) +
        buildHealthTags(state.allergies);
    _macroQuery = mapNutrients(
        state.macronutrients, Options.macronutrients, Options.nutrientTag1);
    _microQuery = mapNutrients(
        state.micronutrients, Options.micronutrients, Options.nutrientTag2);

    print(_healthQuery + _microQuery + _macroQuery);
  }

  Future<void> _loadMoreRecipes(String searchKey) async {
    print("Loading recipes for search key: $searchKey");

    if (_isLoading) return;

    _isLoading = true;

    try {
      final data = await RecipeSearchAPI.searchRecipes(
        searchKey,
        _healthQuery + _macroQuery + _microQuery,
        nextUrl: _nextUrl,
      );

      final newRecipes = data['hits'].map((hit) => hit['recipe']).toList();
      _nextUrl = data['_links']?['next']?['href'];

      print('newrecipes:');
      print(newRecipes);
      print('Number of new recipes: ${newRecipes.length}');

      if (mounted) {
        setState(() {
          if (newRecipes.isNotEmpty) {
            _recipes.addAll(newRecipes);
          } else {
            print("SEARCH RESULTS LIST EMPTY!");
          }
          _isLoading = false;
          _initialLoadComplete = true;
        });
      }
    } catch (e) {
      print('Error: $e');
      // Retry logic
      int retryCount = 0;
      const int maxRetries = 3;
      const Duration retryInterval = Duration(seconds: 2);

      while (retryCount < maxRetries) {
        await Future.delayed(retryInterval);
        retryCount++;
        try {
          final data = await RecipeSearchAPI.searchRecipes(
            searchKey,
            _healthQuery + _macroQuery + _microQuery,
            nextUrl: _nextUrl,
          );

          final newRecipes = data['hits'].map((hit) => hit['recipe']).toList();
          _nextUrl = data['_links']?['next']?['href']; // Update the next URL

          if (mounted) {
            setState(() {
              if (newRecipes.isNotEmpty) {
                _recipes.addAll(newRecipes);
              } else {
                print("SEARCH RESULTS LIST EMPTY!");
              }
              _isLoading = false;
              _initialLoadComplete = true; // Mark initial load as complete
            });
          }
          return; // Exit the retry loop if successful
        } catch (e) {
          print('Retry $retryCount failed: $e');
        }
      }

      // reset loading state on final error
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initialLoadComplete = true; // Mark initial load as complete
        });
      }
    }
  }

  String buildHealthTags(List<dynamic> tags) {
    return tags
        .map((tag) =>
            '&health=${tag.toString().toLowerCase().replaceAll(" ", "-")}')
        .join('');
  }

  String mapNutrients(List<dynamic> nutrients, List<String> optionToMap,
      List<String> tagToMap) {
    Map<String, String> tagMapMacro = Map.fromIterables(optionToMap, tagToMap);
    return nutrients
        .map((nutrient) =>
            '&nutrients%5B${tagMapMacro[nutrient.toString()]}%5D=0%2B')
        .join('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      buildWhen: (previous, current) =>
          current is UserProfileLoaded ||
          current is UserProfileError ||
          current is UserProfileInitial,
      builder: (context, userProfileState) {
        if (userProfileState is UserProfileLoaded) {
          print('userprofilestate is userprofileloaded');

          return BlocListener<SearchRecipeBloc, SearchRecipeState>(
            listener: (context, state) {
              if (state is FavoritesError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Error adding to saved recipes collection.")));
              } else if (state is FavoritesAdded) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Added to saved recipe collection!")));
              } else if (state is FavoritesRemoved) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Removed from saved recipe collection!")));
              } else if (state is RejectedAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Added to rejected recipes!")));
              } else if (state is RejectedRemoved) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Removed from rejected recipes!")));
              } else if (state is RejectedError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Error adding to rejected recipes collection.")));
              }
            },
            child: _buildSearchRecipeUI(userProfileState),
          );
        } else if (userProfileState is UserProfileError) {
          return Center(child: Text(userProfileState.error));
        }
        print('blocbuilder search recipe ui');
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildSearchRecipeUI(UserProfileLoaded state) {
    if (_recipes.isEmpty && !_isLoading && !_initialLoadComplete) {
      print('initialize recipeee');
      _recipes.clear();
      _initializeQueriesAndLoadRecipes(state);
    }
    return _buildRecipeList();
  }

  Widget _buildRecipeList() {
    return Center(
      child: Column(children: <Widget>[
        CustomSearchBar(
          onSubmitted: (searchKey) {
            setState(() {
              _recipes.clear(); // Clear the results first
              _nextUrl = null; // Reset next URL
              _searchKey =
                  searchKey; // Update searchKey with the submitted value
            });
            _loadMoreRecipes(searchKey);
          },
        ),
        SizedBox(height: (10.toVHLength).toPX()),
        Container(
          width:
              double.infinity, // Ensures the container takes up the full width
          padding: EdgeInsets.symmetric(
              horizontal: 22.0), // Adjust padding as needed
          child: Text(
            'Recommended\nfor You',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.purpleColor),
            textAlign: TextAlign.left,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        SizedBox(height: (10.toVHLength).toPX()),
        if (_recipes.isEmpty && !_isLoading && _initialLoadComplete)
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Image.asset(Assets.noMatchingRecipe),
            ),
          ))
        else
          Expanded(
              child: ListView.builder(
                  itemCount:
                      _recipes.length + 1, // Add one for loading indicator
                  itemBuilder: (context, index) {
                    if (index >= _recipes.length) {
                      if (!_isLoading && _nextUrl != null) {
                        // Load more at the end of the list
                        _loadMoreRecipes(_searchKey);
                      } else if (!_isLoading &&
                          _nextUrl == null &&
                          _searchKey.isEmpty) {
                        // Only load default results if searchKey is empty and there are no more next URLs
                        _loadMoreRecipes('');
                      } else if (_nextUrl == null) {
                        return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(child: Text("End of results.")));
                      }
                      return Center(child: CircularProgressIndicator());
                    }
                    final recipe = _recipes[index];
                    return GestureDetector(
                      onTap: () {
                        final recipeId =
                            extractRecipeIdUsingRegExp(recipe['uri']);
                        context.goNamed('viewRecipe',
                            pathParameters: {'recipeId': recipeId});
                      },
                      child: RecipeCard(
                        recipeName: recipe['label'],
                        imageUrl: recipe['images']['THUMBNAIL']['url'],
                        sourceWebsite: recipe['source'],
                        recipeUri: recipe['uri'],
                      ),
                    );
                  })),
      ]),
    );
  }
}

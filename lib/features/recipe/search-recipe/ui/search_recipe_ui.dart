import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/shared/filter/custom_filter.dart';
import 'package:sp_tastebud/shared/recipe_card/bloc/recipe_bloc.dart';
import 'package:sp_tastebud/shared/search_bar/custom_search_bar.dart';
import 'package:sp_tastebud/shared/recipe_card/ui/recipe_card_search.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/recipe_search_api.dart';
import 'package:sp_tastebud/core/utils/extract_recipe_id.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';
import 'package:sp_tastebud/core/config/assets_path.dart';
import 'package:sp_tastebud/features/user-profile/bloc/user_profile_bloc.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/features/ingredients/bloc/ingredients_bloc.dart';
import 'package:sp_tastebud/shared/connectivity/connectivity_listener_widget.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  final IngredientsBloc _ingredientsBloc = GetIt.instance<IngredientsBloc>();
  final UserProfileBloc _userProfileBloc = GetIt.instance<UserProfileBloc>();
  final RecipeCardBloc _recipeCardBloc = GetIt.instance<RecipeCardBloc>();

  final TextEditingController _searchController = TextEditingController();

  final List<dynamic> _recipes = [];
  bool _isLoading = false;
  bool _initialLoadComplete = false;
  bool _appRefresh = false;
  String? _nextUrl;
  String _searchKey = '';
  String _userPreferences = '';
  Timer? _debounce;

  final Map<String, Set<String>> selectedFilters = {
    'diet': {},
    'cuisineType': {},
    'dishType': {},
    'mealType': {},
  };

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);
    _recipeCardBloc.add(LoadInitialData());

    // Load user profile and ingredients upon component mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_userProfileBloc.state is UserProfileLoaded) {
        if (_ingredientsBloc.state is IngredientsLoaded) {
          if (_recipeCardBloc.state is RecipeCardUpdated) {
            print('111111');
            _appRefresh = true;
            _nextUrl = null; // Reset next URL here
            // _getAllIngredients();
            _initializeQueries();
            _loadMoreRecipes('');
          }
        }
      }
    });

    // Create streams to listen to changes to other pages
    _userProfileBloc.stream.listen((state) {
      print(state);
      if (state is UserProfileLoaded || state is UserProfileUpdated) {
        print('22222');
        _initializeQueries();
        _recipes.clear();
        _appRefresh = true;
        _nextUrl = null; // Reset if there are updates
        _loadMoreRecipes(_searchKey);
      }
    });

    // Listener to handle changes in the RecipeCardBloc
    _recipeCardBloc.stream.listen((state) {
      if (state is RecipeCardUpdated && mounted) {
        // Check first if mounted
        setState(() {
          _recipes.removeWhere((recipe) {
            final recipeId = extractRecipeIdUsingRegExp(recipe['uri']);
            return state.rejected.contains(recipeId);
          });
        });
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
        print('4444');
        _searchKey = _searchController.text;
        _recipes.clear();
        _nextUrl = null;
        _loadMoreRecipes(_searchKey);
      });
    });
  }

  void _initializeQueries() {
    _userPreferences = _userProfileBloc.getUserPreferences();
    print('initialize queries: $_userPreferences');
  }

  // // Get all ingredients from IngredientsBloc
  // void _getAllIngredients() {
  //   _allIngredients = _ingredientsBloc.allIngredients;
  // }

  Future<void> _loadMoreRecipes(String searchKey,
      {bool forceUpdate = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      String filterQuery = _buildFilterQuery();

      final data = await RecipeSearchAPI.searchRecipes(
        searchKey: searchKey,
        queryParams: _userPreferences,
        nextUrl: _nextUrl,
        filters: filterQuery,
        forceUpdate: forceUpdate,
      );

      final newRecipes =
          data['hits'].map((hit) => hit['recipe']).where((recipe) {
        final recipeId = extractRecipeIdUsingRegExp(recipe['uri']);
        final currentState = _recipeCardBloc.state;
        return currentState is! RecipeCardUpdated ||
            !currentState.rejected.contains(recipeId);
      }).toList();
      _nextUrl = data['_links']?['next']?['href'];

      if (mounted) {
        // Mounted check
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
      _retryLoadRecipes(searchKey, forceUpdate: forceUpdate);
    }
  }

  // Retry logic
  Future<void> _retryLoadRecipes(String searchKey,
      {bool forceUpdate = false}) async {
    int retryCount = 0;
    const int maxRetries = 3;
    const Duration retryInterval = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      await Future.delayed(retryInterval);
      retryCount++;
      try {
        String filterQuery = _buildFilterQuery();

        final data = await RecipeSearchAPI.searchRecipes(
          searchKey: searchKey,
          queryParams: _userPreferences,
          nextUrl: _nextUrl,
          filters: filterQuery,
          // ingredients: _allIngredients,
          forceUpdate: forceUpdate,
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

    // Reset loading state on final error
    if (mounted) {
      setState(() {
        _isLoading = false;
        _initialLoadComplete = true; // Mark initial load as complete
      });
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

  String _buildFilterQuery() {
    List<String> queries = [];
    selectedFilters.forEach((category, options) {
      options.forEach((option) {
        queries.add('&${category}=${option.replaceAll(" ", "%20")}');
      });
    });
    return queries.join('');
  }

  // Row of filter buttons
  Widget _buildFilterCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 20),
          Text(
            'Filters:',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.purpleColor),
            textAlign: TextAlign.left,
          ),
          SizedBox(width: 15),
          CustomFilter(
            category: 'Diet',
            tag: 'diet',
            options: Options.diet,
            selectedOptions: selectedFilters['diet']!,
            onFilterChanged: (tag, selectedOptions) {
              setState(() {
                selectedFilters[tag] = selectedOptions;
              });
            },
            onFilterCleared: (tag) {
              setState(() {
                selectedFilters[tag]!.clear();
              });
            },
            onApplyFilters: () {
              _recipes.clear(); // Clear the results first
              _nextUrl = null; // Reset next URL
              _loadMoreRecipes(_searchKey);
            },
          ),
          SizedBox(width: 15),
          CustomFilter(
            category: 'Cuisine Type',
            tag: 'cuisineType',
            options: Options.cuisineType,
            selectedOptions: selectedFilters['cuisineType']!,
            onFilterChanged: (tag, selectedOptions) {
              setState(() {
                selectedFilters[tag] = selectedOptions;
              });
            },
            onFilterCleared: (tag) {
              setState(() {
                selectedFilters[tag]!.clear();
              });
            },
            onApplyFilters: () {
              _recipes.clear(); // Clear the results first
              _nextUrl = null; // Reset next URL
              _loadMoreRecipes(_searchKey);
            },
          ),
          SizedBox(width: 15),
          CustomFilter(
            category: 'Dish Type',
            tag: 'dishType',
            options: Options.dishType,
            selectedOptions: selectedFilters['dishType']!,
            onFilterChanged: (tag, selectedOptions) {
              setState(() {
                selectedFilters[tag] = selectedOptions;
              });
            },
            onFilterCleared: (tag) {
              setState(() {
                selectedFilters[tag]!.clear();
              });
            },
            onApplyFilters: () {
              _recipes.clear(); // Clear the results first
              _nextUrl = null; // Reset next URL
              _loadMoreRecipes(_searchKey);
            },
          ),
          SizedBox(width: 15),
          CustomFilter(
            category: 'Meal Type',
            tag: 'mealType',
            options: Options.mealType,
            selectedOptions: selectedFilters['mealType']!,
            onFilterChanged: (tag, selectedOptions) {
              setState(() {
                selectedFilters[tag] = selectedOptions;
              });
            },
            onFilterCleared: (tag) {
              setState(() {
                selectedFilters[tag]!.clear();
              });
            },
            onApplyFilters: () {
              _recipes.clear(); // Clear the results first
              _nextUrl = null; // Reset next URL
              _loadMoreRecipes(_searchKey);
            },
          ),
          SizedBox(width: 15)
        ],
      ),
    );
  }

  // original
  @override
  Widget build(BuildContext context) {
    return ConnectivityListenerWidget(
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        buildWhen: (previous, current) =>
            current is UserProfileLoaded ||
            current is UserProfileError ||
            current is UserProfileInitial,
        builder: (context, userProfileState) {
          if (userProfileState is UserProfileLoaded) {
            return _buildSearchRecipeUI(userProfileState);
          } else if (userProfileState is UserProfileError) {
            return Center(child: Text(userProfileState.error));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSearchRecipeUI(UserProfileLoaded state) {
    if (_recipes.isEmpty && !_isLoading && !_initialLoadComplete) {
      _recipes.clear();
      // _getAllIngredients();
      _initializeQueries();
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

        // Page tagline
        Container(
          width:
              double.infinity, // Ensures the container takes up the full width
          padding: EdgeInsets.symmetric(horizontal: 22.0),
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

        SizedBox(height: (5.toVHLength).toPX()),

        // Filters
        _buildFilterCategories(),
        SizedBox(height: (10.toVHLength).toPX()),

        // // Apply Filters Button
        // ElevatedButton(
        //   onPressed: () {
        //     _loadMoreRecipes(_searchKey);
        //   },
        //   child: Text('Apply Filters'),
        //   style: ElevatedButton.styleFrom(
        //     foregroundColor: AppColors.orangeDarkerColor,
        //     backgroundColor: AppColors.orangeDisabledColor,
        //   ),
        // ),
        // SizedBox(height: (10.toVHLength).toPX()),

        if (_recipes.isEmpty && !_isLoading && _initialLoadComplete)
          // If no matching recipe
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Image.asset(Assets.noMatchingRecipe),
            ),
          ))
        else
          // Display recipe list
          Expanded(
              child: ListView.builder(
                  itemCount:
                      _recipes.length + 1, // Add one for loading indicator
                  itemBuilder: (context, index) {
                    if (index >= _recipes.length) {
                      if (!_isLoading && _nextUrl != null) {
                        // Load more at the end of the list
                        _loadMoreRecipes(_searchKey);
                      } else if (!_isLoading && _nextUrl == null) {
                        if (_searchKey.isEmpty) {
                          // Only load default results if searchKey is empty and there are no more next URLs
                          _loadMoreRecipes('');
                        } else {
                          return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Center(child: Text("End of results.")));
                        }
                      } else if (_nextUrl == null &&
                          _initialLoadComplete &&
                          !_appRefresh) {
                        return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(child: Text("End of results.")));
                      }
                      return Center(child: CircularProgressIndicator());
                    }
                    final recipe = _recipes[index];
                    final recipeId = extractRecipeIdUsingRegExp(recipe['uri']);

                    // Check if the recipe is in the rejected collection
                    if ((_recipeCardBloc.state as RecipeCardUpdated)
                        .rejected
                        .contains(recipeId)) {
                      // Return an empty container if the recipe is rejected
                      return Container();
                    }

                    return GestureDetector(
                      onTap: () {
                        context.goNamed('viewRecipe', pathParameters: {
                          'recipeId': recipeId,
                        });
                      },
                      child: RecipeCardSearch(
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

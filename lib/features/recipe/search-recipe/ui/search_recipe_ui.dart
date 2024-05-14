import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import 'package:sp_tastebud/shared/custom_dialog.dart';
import 'package:sp_tastebud/shared/search_bar/custom_search_bar.dart';
import 'package:sp_tastebud/shared/recipe_card/recipe_card.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/recipe_search_api.dart';
import 'package:sp_tastebud/core/config/service_locator.dart';
import 'package:sp_tastebud/core/utils/extract_recipe_id.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';
import '../../../user-profile/bloc/user_profile_bloc.dart';
import '../bloc/search_recipe_bloc.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  // used for fetching user details
  List<bool> selectedDietaryPreferences = [];
  List<bool> selectedAllergies = [];
  List<bool> selectedMacronutrients = [];
  List<bool> selectedMicronutrients = [];

  // store query parameters
  String _healthQuery = '';
  String _macroQuery = '';
  String _microQuery = '';

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _recipes = [];
  bool _isLoading = false;
  String _searchKey = '';
  String _lastSearchKey = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    // Listen to the user profile loaded state
    // addPostFrameCallback to defer actions until after the build phase completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfileBloc = getIt<UserProfileBloc>();
      if (userProfileBloc.state is UserProfileLoaded) {
        _initializeQueriesAndLoadRecipes(
            userProfileBloc.state as UserProfileLoaded);
        // Ensure the searchKey or initial parameters are set before calling
        _loadMoreRecipes(_searchKey);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      // Handle case for empty search or reset
    } else {
      _loadMoreRecipes(_searchController.text);
    }
  }

  void _initializeQueriesAndLoadRecipes(UserProfileLoaded state) {
    // setState(() {
    //   _healthQuery = buildHealthTags(state.dietaryPreferences) +
    //       buildHealthTags(state.allergies);
    //   _macroQuery = mapNutrients(state.macronutrients,
    //       Options.macronutrients, Options.nutrientTag1);
    //   _microQuery = mapNutrients(state.micronutrients,
    //       Options.micronutrients, Options.nutrientTag2);
    // });

    // Building the queries based on the loaded user profile state
    _healthQuery = buildHealthTags(state.dietaryPreferences) +
        buildHealthTags(state.allergies);
    _macroQuery = mapNutrients(
        state.macronutrients, Options.macronutrients, Options.nutrientTag1);
    _microQuery = mapNutrients(
        state.micronutrients, Options.micronutrients, Options.nutrientTag2);

    print(_healthQuery + _microQuery + _macroQuery);

    // Loading the first set of recipes
    // _loadMoreRecipes(_searchKey);
    // Only load recipes if the user explicitly performs an action or if it's necessary upon initial load
    // Consider triggering the initial recipe load with a user action or a different lifecycle method
  }

  // Call the recipe search api
  Future<void> _loadMoreRecipes(String searchKey) async {
    print("Loading recipes for search key: $searchKey");

    if (_isLoading) return; // Prevent multiple simultaneous loads

    if (_lastSearchKey != searchKey) {
      _recipes.clear(); // Clear the recipes if the search key has changed
      _lastSearchKey = searchKey; // Update the last search key
    }

    // setState(() => _isLoading = true);
    _isLoading = true;

    try {
      var query = '$_healthQuery$_macroQuery$_microQuery';
      print("query");
      print(query);

      final newRecipes = await RecipeSearchAPI.searchRecipes(searchKey, query,
          start: 0, end: _recipes.length + 10);

      print('newrecipes:');
      print(newRecipes);

      if (mounted) {
        if (newRecipes.isNotEmpty) {
          setState(() {
            _recipes.addAll(newRecipes);
          });
          // Ensure to turn off the loading indicator
          _isLoading = false;
        } else {
          print("SEARCH RESULTS LIST EMPTY!");
        }
      }
    } catch (e) {
      print('Error: $e');
      // reset loading state on error
      if (mounted) {
        setState(() {
          _isLoading = false;
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
    // Accessing UserProfileBloc using BlocBuilder
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
                    content: Text("Error adding to recipe collection")));
              } else if (state is FavoritesAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Added to recipe collection!")));
              }
            },
            child: _buildSearchRecipeUI(userProfileState),
          );
        } else if (userProfileState is UserProfileError) {
          // Show error message if loading fails
          return Center(child: Text(userProfileState.error));
        } else if (userProfileState is UserProfileInitial) {
          return Center(child: Text("Initial"));
        }
        // Fallback widget
        print('blocbuilder search recipe ui');
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildSearchRecipeUI(UserProfileLoaded state) {
    // Check to prevent multiple initial loads
    if (_recipes.isEmpty) {
      print('initialize recipeee');
      _initializeQueriesAndLoadRecipes(state);
    }
    return _buildRecipeList();
  }

  Widget _buildRecipeList() {
    // print("FETCHED USER PROFILE:");
    // print(state.dietaryPreferences);
    // print(state.allergies);
    // print(state.macronutrients);
    // print(state.micronutrients);

    // String healthQuery = buildHealthTags(state.dietaryPreferences) +
    //     buildHealthTags(state.allergies);
    // String macroQuery = mapNutrients(
    //     state.macronutrients, Options.macronutrients, Options.nutrientTag1);
    // String microQuery = mapNutrients(
    //     state.micronutrients, Options.micronutrients, Options.nutrientTag2);

    return Center(
      child: Column(children: <Widget>[
        // search bar
        CustomSearchBar(
          onSubmitted: (searchKey) => _loadMoreRecipes(searchKey),
        ),

        // sample button for dialog
        SizedBox(
          width: (MediaQuery.of(context).size.width / 6) * 4.5,
          child: ElevatedButton(
            onPressed: () {
              openDialog(context, "Sample Title", "Lorem ipsum dolor sit amet");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: '#F06F6F'.toColor(),
              foregroundColor: const Color(0xFFF7EBE8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            child: const Text("Click Me"),
          ),
        ),

        const SizedBox(height: 20),

        // search results
        Expanded(
          child: ListView.builder(
            itemCount: _recipes.length + 1, // Add one for loading indicator
            itemBuilder: (context, index) {
              if (index >= _recipes.length) {
                if (!_isLoading) {
                  _loadMoreRecipes(
                      _searchKey); // Load more at the end of the list
                }
                return Center(child: CircularProgressIndicator());
              }
              final recipe = _recipes[index];
              return GestureDetector(
                onTap: () {
                  // Get the recipe data as a Map or directly pass the Recipe object if serialized
                  final recipeId = extractRecipeIdUsingRegExp(recipe['uri']);
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
            },
          ),
        )
      ]),
    );
  }
}

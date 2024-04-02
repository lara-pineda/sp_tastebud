import 'package:flutter/material.dart';
import 'package:sp_tastebud/features/ingredients/ui/ingredient_management_ui.dart';
import 'package:sp_tastebud/features/recipe-collection/ui/recipe_collection_ui.dart';
// main pages
import 'package:sp_tastebud/features/recipe/search-recipe/ui/search_recipe_ui.dart';
import 'package:sp_tastebud/features/user-profile/ui/user_profile_ui.dart';

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.explore_outlined),
    activeIcon: Icon(Icons.explore),
    label: 'Explore',
  ),

  // ingredients management page
  BottomNavigationBarItem(
    icon: Icon(Icons.dashboard_outlined),
    activeIcon: Icon(Icons.dashboard),
    label: 'Ingredients',
  ),

  // recipe collection
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_border),
    activeIcon: Icon(Icons.favorite),
    label: 'Collection',
  ),

  // user profile
  BottomNavigationBarItem(
    icon: Icon(Icons.account_circle_outlined),
    activeIcon: Icon(Icons.account_circle),
    label: 'Profile',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  const SearchRecipe(),
  const IngredientManagement(),
  const RecipeCollection(),
  const UserProfile(),
];

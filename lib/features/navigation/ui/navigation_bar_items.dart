import 'package:flutter/material.dart';

List<NavigationDestination> bottomNavItems = const <NavigationDestination>[
  NavigationDestination(
    icon: Icon(Icons.explore_outlined),
    selectedIcon: Icon(Icons.explore),
    label: 'Explore',
  ),

  // ingredients management page
  NavigationDestination(
    icon: Icon(Icons.dashboard_outlined),
    selectedIcon: Icon(Icons.dashboard),
    label: 'Ingredients',
  ),

  // recipe collection
  NavigationDestination(
    icon: Icon(Icons.favorite_border),
    selectedIcon: Icon(Icons.favorite),
    label: 'Collection',
  ),

  // user profile
  NavigationDestination(
    icon: Icon(Icons.account_circle_outlined),
    selectedIcon: Icon(Icons.account_circle),
    label: 'Profile',
  ),
];

import 'package:flutter/material.dart';

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

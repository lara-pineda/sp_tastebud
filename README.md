# TasteBud: A Food Recommendation System for Mobile Devices

Flutter Project for CMSC 190-2 (A.Y. 2023-2024)
Author: Lara Patricia B. Pineda
        lbpineda1@up.edu.ph
        Institute of Computer Science,
        College of Arts and Sciences,
        University of the Philippines Los Baños

## 📌 File Structure
```
sp_tastebud/
│
├── .dart_tool/
├── .idea/
├── android/
├── assets/                                 # Non-code resources like images, fonts, etc.
│   ├── google_fonts/
│   ├── images/
│   └── wireframe/
├── build/
├── ios/
└── lib/
    ├── core/
    │   ├── config/                         # Essential for the app
    │   │   ├── app_router.dart             # Defines routes for navigation
    │   │   ├── assets_path.dart            # Resource path for assets
    │   │   └── service_locator.dart        # Dependency injection
    │   │
    │   ├── themes/                         # Custom app theme
    │   │   ├── app_palette.dart
    │   │   └── app_typography.dart
    │   │
    │   └── utils/                          # Holds utility/helper functions shared across the app
    │       ├── extract_recipe_id.dart      # Extracts the recipe id from a string
    │       ├── get_current_route.dart      # Gets route path of a widget
    │       └── hex_to_color.dart           # Converts hex to dart color
    │
    ├── features/                           # App features
    │   ├── auth/
    │   ├── ingredients/
    │   ├── navigation/
    │   ├── recipe/
    │   │   ├── search-recipe/
    │   │   └── view-recipe/
    │   ├── recipe-collection/
    │   └── user-profile/
    │
    ├── shared/                             # Reusable small, custom widgets used in the pages
    │   ├── checkbox_card/
    │   ├── recipe_card/
    │   └── search_bar/
    │
    ├── firebase_options.dart               # For firebase
    └── main.dart                           # Entry point that launches the application
```

## Features TODO

-   wag siguro ilagay sa query allergies para lumabas pa rin sa results and mapakita substitute ingredients
-   substitute recipe
-   if nasa rejected recipes, di na dapat lumabas sa search results

MINOR STUFF
-   no notif if save is successful sa ingredient mgmt and user profile
-   implement debounce on recipe collection
-   nagrerefresh page sa recipe collection pag nagreremove, wag na sana refresh, updatelist na lang
-   check if wifi is on
-   add more filters
-   confirmation windows for:
    - saving changes when switching tabs
    - rejecting a favorited recipe
- bakit sobrang laki ng circle loading indicator sa umpisa
- getIt<IngredientsBloc> vs GetIt.instance<IngredientsBloc>()
- add to favorites/reject recipe from view recipe page

SUGGESTIONS
-   manage equipments
-   leave a review


Functions to test:
1. Sign up
2. Login
3. Forgot password
4. Logout
5. Change email
6. Update User Profile
7. Update Ingredients
8. Save recipe
9. Reject recipe
10. Search recipe
11. Filter recipe
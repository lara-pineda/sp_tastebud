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

-   add ingredients to query
-   connect firestore methods to ui layer for collection
-   substitute recipe

MINOR STUFF
-   navigation change color
-   view recipe details polish styling
-   dialog styling
-   move save changes button for ingredient mgmt and user profile
-   page for empty search results
-   logout button
-   make user email not editable
-   finalize options for ingredients
-   add more filters
-   forgot password

SUGGESTIONS
-   manage equipments
-   leave a review

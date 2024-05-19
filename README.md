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
├── assets/                                     # Non-code resources like images, fonts, etc.
│   ├── google_fonts/
│   ├── images/
│   └── wireframe/
├── build/
├── ios/
└── lib/
    ├── core/
    │   ├── config/                             # Essential for the app
    │   │   ├── app_router.dart                 # Defines routes for navigation
    │   │   ├── assets_path.dart                # Resource path for assets
    │   │   ├── connectivity_service.dart       # Checker for internet connection on device
    │   │   └── service_locator.dart            # Dependency injection
    │   │
    │   ├── themes/                             # Custom app theme
    │   │   ├── app_palette.dart
    │   │   └── app_typography.dart
    │   │
    │   └── utils/                              # Holds utility/helper functions shared across the app
    │       ├── capitalize_first_letter.dart    # Capitalizes the first letter of all words in a string
    │       ├── extract_recipe_id.dart          # Extracts the recipe id from a string
    │       ├── get_current_route.dart          # Gets route path of a widget
    │       ├── hex_to_color.dart               # Converts hex to dart color
    │       ├── load_svg.dart                   # Loads a given svg file to UI layer
    │       └── user_not_found_exception.dart   # Custom exception to throw
    │
    ├── features/                               # App features
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
    │   ├── custom_dialog/
    │   ├── recipe_card/
    │   └── search_bar/
    │
    ├── firebase_options.dart               # For firebase
    └── main.dart                           # Entry point that launches the application
```

## Features TODO

TODO
-   substitute recipe
-   add more filters (in progress)
-   wag siguro ilagay sa query allergies para lumabas pa rin sa results and mapakita substitute ingredients?
-   confirmation windows for saving changes when switching tabs
-   if sa drawer nagcheck ng checklist, hindi napapasa sa checkbox card yung state (in progress)

REASONABLE
-   if tinanggal sa rejected recipes collection, hindi babalik agad sa ui (reasonable use case?)
-   success/error dialog sa pag-add/remove from collection (di na need, may confirmation naman and ui change if successful)

SUGGESTIONS
-   add collection for rejected recipes (done)
-   add more information regarding options (done)
-   add more filters
-   manage equipments
-   leave a review


Functions to test:
1. Sign up
2. Login
3. Forgot password
4. Logout
5. Change email (if kaya)
6. Update User Profile
7. Update Ingredients
8. Save recipe from search, view
9. Reject recipe from search, view
10. Remove recipe from collection from search, view, collection page
11. Search recipe
12. Filter recipe
13. Try magpalabas ng errors
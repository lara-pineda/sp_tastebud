# TasteBud: A Food Recommendation System for Mobile Devices

* Flutter Project for CMSC 190-2 (A.Y. 2023-2024)
* Author: Lara Patricia B. Pineda
* lbpineda1@up.edu.ph
* Institute of Computer Science,
* College of Arts and Sciences,
* University of the Philippines Los Baños

## 📌 File Structure
```
sp_tastebud/
│
├── .dart_tool/
├── .gradle/
├── .idea/
├── android/
├── assets/                                     # Non-code resources like images, fonts, etc.
│   ├── google_fonts/
│   ├── images/
│   └── wireframe/
├── build/                                      # Contains the apk in build/outputs/apk/release
├── ios/
├── lib/                                        # The actual source code written by the developer
│   ├── core/
│   │   ├── config/                             # Essential for the app
│   │   │   ├── app_router.dart                 # Defines routes for navigation
│   │   │   ├── assets_path.dart                # Resource path for image assets
│   │   │   └── service_locator.dart            # For dependency injection
│   │   │
│   │   ├── themes/                             # Custom app theme
│   │   │   ├── app_palette.dart
│   │   │   └── app_typography.dart
│   │   │
│   │   └── utils/                              # Holds utility/helper functions shared across the app
│   │       ├── capitalize_first_letter.dart    # Capitalizes the first letter of all words in a string
│   │       ├── extract_recipe_id.dart          # Extracts the recipe id from a string
│   │       ├── get_current_route.dart          # Gets route path of a widget
│   │       ├── hex_to_color.dart               # Converts hex to dart color
│   │       ├── load_svg.dart                   # Loads a given svg file to UI layer
│   │       └── user_not_found_exception.dart   # Custom exception to throw
│   │
│   ├── features/                               # App features
│   │   ├── auth/
│   │   ├── ingredients/
│   │   ├── navigation/
│   │   ├── recipe/
│   │   │   ├── search-recipe/
│   │   │   └── view-recipe/
│   │   ├── recipe-collection/
│   │   └── user-profile/
│   │
│   ├── shared/                                 # Reusable small, custom widgets used in the pages
│   │   ├── checkbox_card/
│   │   ├── connectivity/
│   │   ├── custom_dialog/
│   │   ├── filter/
│   │   ├── recipe_card/
│   │   └── search_bar/
│   │
│   ├── firebase_options.dart                   # For firebase
│   └── main.dart                               # Entry point that launches the application
│
├── test/
├── firebase.json                               # Automatically generated file upon connecting the app to firebase console
└── pubspec.yaml                                # Contains the app dependencies
```


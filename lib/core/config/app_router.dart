import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/config/service_locator.dart';

// UI widgets
import 'package:sp_tastebud/features/auth/ui/login_ui.dart';
import 'package:sp_tastebud/features/auth/ui/main_menu_ui.dart';
import 'package:sp_tastebud/features/auth/ui/signup_ui.dart';
import 'package:sp_tastebud/features/ingredients/ui/ingredient_management_ui.dart';
import 'package:sp_tastebud/features/navigation/ui/navigation_bar_ui.dart';
import 'package:sp_tastebud/features/recipe-collection/ui/recipe_collection_ui.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/ui/search_recipe_ui.dart';
import 'package:sp_tastebud/features/user-profile/ui/user_profile_ui.dart';
import 'package:sp_tastebud/features/recipe/view-recipe/ui/view_recipe_ui.dart';

//BLoCs
import 'package:sp_tastebud/features/auth/bloc/auth_bloc.dart';
import 'package:sp_tastebud/features/user-profile/bloc/user_profile_bloc.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/bloc/search_recipe_bloc.dart';
import 'package:sp_tastebud/features/ingredients/bloc/ingredients_bloc.dart';

class AppRoutes {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorSearchKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
  static final _shellNavigatorIngredientsKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellIngredients');
  static final _shellNavigatorCollectionKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellCollection');
  static final _shellNavigatorProfileKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

  static GoRouter get router => GoRouter(
        initialLocation: "/",
        navigatorKey: _rootNavigatorKey,
        routes: [
          GoRoute(
            name: "mainMenu",
            path: "/",
            builder: (context, state) =>
                const MainMenu(appName1: "Taste", appName2: "Bud"),
          ),
          GoRoute(
            name: "login",
            path: "/login",
            builder: (context, state) {
              return BlocProvider<AuthBloc>(
                create: (context) => getIt<AuthBloc>(),
                child: LoginPage(),
              );
            },
          ),
          GoRoute(
            name: "signup",
            path: "/signup",
            builder: (context, state) {
              return BlocProvider<AuthBloc>(
                create: (context) => getIt<AuthBloc>(),
                child: SignupPage(),
              );
            },
          ),
          StatefulShellRoute.indexedStack(
              builder: (context, state, navigationShell) {
                return AppBottomNavBar(
                    appName1: 'Taste',
                    appName2: 'Bud',
                    navigationShell: navigationShell);
              },
              branches: [
                StatefulShellBranch(
                    navigatorKey: _shellNavigatorSearchKey,
                    routes: [
                      GoRoute(
                        name: "search",
                        path: "/search",
                        builder: (context, state) =>
                            BlocProvider<SearchRecipeBloc>(
                          create: (context) => getIt<SearchRecipeBloc>(),
                          child: const SearchRecipe(),
                        ),
                        routes: [
                          GoRoute(
                            name: "viewRecipe",
                            path: "view",
                            builder: (context, state) =>
                                BlocProvider<SearchRecipeBloc>(
                              create: (context) => getIt<SearchRecipeBloc>(),
                              child: const ViewRecipe(),
                            ),
                          ),
                        ],
                      ),
                    ]),
                // Ingredients branch
                StatefulShellBranch(
                  navigatorKey: _shellNavigatorIngredientsKey,
                  routes: [
                    GoRoute(
                      path: '/ingredients',
                      builder: (context, state) =>
                          BlocProvider<IngredientsBloc>(
                        create: (context) => getIt<IngredientsBloc>(),
                        child: const IngredientManagement(),
                      ),
                    ),
                  ],
                ),
                // Recipe Collection branch
                StatefulShellBranch(
                  navigatorKey: _shellNavigatorCollectionKey,
                  routes: [
                    GoRoute(
                      path: '/recipe-collection',
                      builder: (context, state) =>
                          BlocProvider<SearchRecipeBloc>(
                        create: (context) => getIt<SearchRecipeBloc>(),
                        child: const RecipeCollection(),
                      ),
                    ),
                  ],
                ),
                // User Profile branch
                StatefulShellBranch(
                  navigatorKey: _shellNavigatorProfileKey,
                  routes: [
                    GoRoute(
                      path: '/profile',
                      builder: (context, state) =>
                          BlocProvider<UserProfileBloc>(
                        create: (context) => getIt<UserProfileBloc>(),
                        child: UserProfile(),
                      ),
                    ),
                  ],
                ),
              ])
        ],
      );
}

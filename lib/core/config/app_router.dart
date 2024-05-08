import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_provider/go_provider.dart';
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

//BLoCs
import 'package:sp_tastebud/features/auth/bloc/auth_bloc.dart';
import 'package:sp_tastebud/features/user-profile/bloc/user_profile_bloc.dart';
import 'package:sp_tastebud/features/navigation/bloc/app_navigation_bloc.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/bloc/search_recipe_bloc.dart';
import 'package:sp_tastebud/features/ingredients/bloc/ingredients_bloc.dart';

class AppRoutes {
  // for the parent navigation stack
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // for nested navigation with ShellRoute
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

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
          ShellProviderRoute(
            navigatorKey: _shellNavigatorKey,
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) => getIt<AuthBloc>(),
              ),
              BlocProvider<UserProfileBloc>(
                create: (context) => getIt<UserProfileBloc>(),
              ),
              BlocProvider<IngredientsBloc>(
                create: (context) => getIt<IngredientsBloc>(),
              ),
              BlocProvider<SearchRecipeBloc>(
                create: (context) => getIt<SearchRecipeBloc>(),
              ),
            ],
            builder: (context, state, child) {
              return BlocProvider<AppNavigationBloc>(
                create: (context) => AppNavigationBloc(),
                child: AppBottomNavBar(appName1: 'Taste', appName2: 'Bud'),
              );
            },
            routes: [
              GoRoute(
                name: "search",
                path: "/search",
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const SearchRecipe(),
                // child route
                // routes:[
                //   GoRoute(
                //     name: "viewRecipe",
                //     path: "view-recipe",
                //     parentNavigatorKey: _rootNavigatorKey,
                //     builder: (context, state) => const ViewRecipe(),
                //     path: ":id",
                //     builder: (context, state) {
                //       final id = state.params['id'] // Get "id" param from URL
                //       return FruitsPage(id: id);
                //     },
                //    example path: /fruits?search=antonio
                //    builder: (context, state) {
                //      final search = state.queryParams['search'];
                //      return FruitsPage(search: search);
                //    },
                //   )
                // ]
              ),
              GoRoute(
                name: "ingredientManagement",
                path: "/ingredients",
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const IngredientManagement(),
              ),
              GoRoute(
                name: "recipeCollection",
                path: "/recipe-collection",
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const RecipeCollection(),
              ),
              GoRoute(
                name: "userProfile",
                path: "/profile",
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => UserProfile(),
              ),
            ],
          ),
        ],
      );
}

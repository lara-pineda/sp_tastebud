import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// UI widgets
import 'features/auth/ui/login_ui.dart';
import 'features/auth/ui/main_menu_ui.dart';
import 'features/auth/ui/signup_ui.dart';
import 'features/ingredients/ui/ingredient_management_ui.dart';
import 'features/navigation/ui/navigation_bar_ui.dart';
import 'features/recipe-collection/ui/recipe_collection_ui.dart';
import 'features/recipe/search-recipe/ui/search_recipe_ui.dart';
import 'features/user-profile/ui/user_profile_ui.dart';

// Blocs
import 'features/navigation/bloc/app_navigation_bloc.dart';
import 'features/auth/bloc/signup_bloc.dart';
import 'features/auth/bloc/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // removes debug tag when running app test
      debugShowCheckedModeBanner: false,

      title: 'TasteBud',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      routerConfig: _router,

      /// components
      // home: const CustomSearchBar(),
      // home: const RecipeCard(),
      // home: const UserCard(),
    );
  }

  // for the parent navigation stack
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // for nested navigation with ShellRoute
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  // routes
  late final _router = GoRouter(
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
          return BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(FirebaseAuth.instance),
            child: LoginPage(),
          );
        },
      ),
      GoRoute(
        name: "signup",
        path: "/signup",
        builder: (context, state) {
          return BlocProvider<SignupBloc>(
            create: (context) => SignupBloc(FirebaseAuth.instance),
            child: SignupPage(),
          );
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
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
            builder: (context, state) => const UserProfile(),
          ),
        ],
      )
    ],
  );
}

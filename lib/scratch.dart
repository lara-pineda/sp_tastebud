class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
          lazy: false,
        ),
        BlocProvider<UserProfileBloc>(
          create: (context) => getIt<UserProfileBloc>(),
          lazy: false,
        ),
        BlocProvider<IngredientsBloc>(
          create: (context) => getIt<IngredientsBloc>(),
          lazy: false,
        ),
      ],
      child: MaterialApp.router(
        // removes debug tag when running app test
        debugShowCheckedModeBanner: false,
        title: 'TasteBud',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}

class AppRoutes {
  static GoRouter get router => GoRouter(
        initialLocation: "/scratch",
        routes: [
          GoRoute(
            name: 'scratch',
            path: '/scratch',
            builder: (context, state) => ScratchCollection(),
          ),
        ],
      );
}


import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/core/config/assets_path.dart';

import '../../auth/bloc/auth_bloc.dart';

class RecipeCollection extends StatelessWidget {
  RecipeCollection({super.key});

  // Retrieve AuthBloc using GetIt
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  Widget _buildCollectionScreen(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: Column(
              children: [
                SizedBox(height: (50.toVHLength).toPX()),
                Text(
                  'Collection',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.purpleColor
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
              ],
            ),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // Number of columns
            crossAxisSpacing: 10,  // Horizontal space between cards
            mainAxisSpacing: 20,  // Vertical space between cards
            childAspectRatio: 1.0 / 1.2,  // Aspect ratio to accommodate text outside the card
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              List<String> titles = ['Saved Recipes', 'Rejected Recipes'];
              return _buildRecipeCard(titles[index]);
            },
            childCount: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(String title) {
    String image = title == 'Saved Recipes' ? Assets.savedRecipe : Assets.rejectedRecipe;
    return Column(
      mainAxisSize: MainAxisSize.min,  // Use minimum space needed by child widgets
      children: [
        Card(
          elevation: 10,
          shadowColor: Colors.grey.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 200,  // Fixed height for image card
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      builder: (context, AuthState state) {
        if (state is AuthFailure) {
          context.go('/');
          return Text("User not logged in.");
        } else {
          return Scaffold(
            body: _buildCollectionScreen(context),
          );
        }
      },
    );
  }
}


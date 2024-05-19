import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/config/app_router.dart';
import 'package:sp_tastebud/features/ingredients/bloc/ingredients_bloc.dart';
import 'package:sp_tastebud/shared/recipe_card/bloc/recipe_bloc.dart';
import 'shared/connectivity/connectivity_service.dart';
import 'core/config/service_locator.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/user-profile/bloc/user_profile_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up dependency injection container before the app starts
  setupServices();

  // log all transitions, including closures
  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // make it uncloseable
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text(
              'This app requires an internet connection. Please check your connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // The dialog cannot be closed until the connection is restored
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

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
          BlocProvider<RecipeCardBloc>(
            create: (context) => getIt<RecipeCardBloc>(),
            lazy: false,
          ),
          BlocProvider<ConnectivityCubit>(
              create: (context) =>
                  ConnectivityCubit(getIt<ConnectivityService>()),
              lazy: false),
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
            builder: (context, child) => BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      // Trigger user profile and ingredients fetch upon successful authentication.
                      getIt<UserProfileBloc>().add(LoadUserProfile());
                      getIt<IngredientsBloc>().add(LoadIngredients());
                      getIt<RecipeCardBloc>().add(LoadInitialData());
                    }
                  },
                  child: child!,
                  // builder: (context, child) => BlocListener<AuthBloc, AuthState>(
                  //       listener: (context, state) {
                  //         if (state is AuthSuccess) {
                  //           // Trigger user profile and ingredients fetch upon successful authentication.
                  //           getIt<UserProfileBloc>().add(LoadUserProfile());
                  //           getIt<IngredientsBloc>().add(LoadIngredients());
                  //           getIt<RecipeCardBloc>().add(LoadInitialData());
                  //         }
                  //       },
                  //       child: child!,
                  // child: BlocListener<ConnectivityCubit, ConnectivityStatus>(
                  //   listener: (context, status) {
                  //     if (status == ConnectivityStatus.disconnected) {
                  //       WidgetsBinding.instance.addPostFrameCallback((_) {
                  //         if (context.mounted) {
                  //           _showNoInternetDialog(context);
                  //         }
                  //       });
                  //     } else {
                  //       WidgetsBinding.instance.addPostFrameCallback((_) {
                  //         if (context.mounted && Navigator.canPop(context)) {
                  //           Navigator.of(context, rootNavigator: true)
                  //               .popUntil((route) => route.isFirst);
                  //         }
                  //       });
                  //     }
                  //   },
                  //   child: MaterialApp.router(
                  //     debugShowCheckedModeBanner: false,
                  //     title: 'TasteBud',
                  //     theme: ThemeData(
                  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
                  //       scaffoldBackgroundColor: Colors.white,
                  //       useMaterial3: true,
                  //     ),
                  //     routerConfig: AppRoutes.router,
                  //   ),
                  // ),
                )));
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('${bloc.runtimeType} is closing');
  }
}

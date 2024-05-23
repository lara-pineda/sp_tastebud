import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/core/config/app_router.dart';
import 'package:sp_tastebud/features/ingredients/bloc/ingredients_bloc.dart';
import 'package:sp_tastebud/shared/recipe_card/bloc/recipe_bloc.dart';
import 'shared/connectivity/connectivity_service.dart';
import 'core/config/service_locator.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/user-profile/bloc/user_profile_bloc.dart';
import 'firebase_options.dart';
import 'dart:io';

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

  // for post request
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        // global blocs
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

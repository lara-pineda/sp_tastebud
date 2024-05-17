import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/config/app_router.dart';
import 'package:sp_tastebud/features/ingredients/bloc/ingredients_bloc.dart';
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
        // routeInformationParser: AppRoutes.router.routeInformationParser,
        // routerDelegate: AppRoutes.router.routerDelegate,

        builder: (context, child) => BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // Trigger user profile and ingredients fetch upon successful authentication.
              getIt<UserProfileBloc>().add(LoadUserProfile());
              getIt<IngredientsBloc>().add(LoadIngredients());
            }
          },
          child: child!,
        ),
      ),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('${bloc.runtimeType} is closing');
  }
}

// class AppRoutes {
//   static GoRouter get router => GoRouter(
//         initialLocation: "/",
//         routes: [
//           GoRoute(
//             name: "forgotPassword",
//             path: "/",
//             builder: (context, state) => ForgotPassword(),
//           ),
//           // builder: (context, state) {
//           //   return BlocProvider<ViewRecipeBloc>(
//           //       create: (context) => getIt<ViewRecipeBloc>(),
//           //       child: Scaffold(
//           //         body: const ViewRecipe(
//           //           recipeId: '067f0b7be628ae847366e4f3e614b319',
//           //         ),
//           //       ));
//           // }),
//         ],
//       );
// }

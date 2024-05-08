import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sp_tastebud/core/config/app_router.dart';
import 'core/config/service_locator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up dependency injection container before the app starts
  setupServices();

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

      routerConfig: AppRoutes.router,

      // routerDelegate: AppRoutes.router.routerDelegate,
      // routeInformationParser: AppRoutes.router.routeInformationParser,
    );
  }
}

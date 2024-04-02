import 'package:flutter/material.dart';

import 'features/navigation/ui/view/generated_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // initialize firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // removes debug tag when running app test
      debugShowCheckedModeBanner: false,

      /// App Name
      title: 'TasteBud',

      /// App Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      initialRoute: '/',
      onGenerateRoute: RouteGenerator().generateRoute,

      /// main menu screen
      // home: const MainMenu(appName1: 'Taste', appName2: 'Bud'),
      // home: const LoginPage(),
      // home: const SignupPage(),

      /// components
      // home: const CustomSearchBar(),
      // home: const RecipeCard(),
      // home: const UserCard(),
    );
  }
}

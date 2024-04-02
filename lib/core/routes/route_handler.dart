import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // final args = settings.arguments;

  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => BlocProvider<AppNavigationBloc>.value(
          value: appNavBloc,
          child: const AppBottomNavBar(appName1: 'Taste', appName2: 'Bud'),
        ),
      );

    default:
      return _errorRoute();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/features/navigation/bloc/app_navigation_bloc.dart';
import 'package:sp_tastebud/features/navigation/ui/navigation_bar_ui.dart';

class RouteGenerator {
  final AppNavigationBloc appNavBloc = AppNavigationBloc();

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

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

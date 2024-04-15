part of 'app_navigation_bloc.dart';

@immutable
abstract class AppNavigationState {
  final int tabIndex;

  const AppNavigationState({required this.tabIndex});
}

class AppNavigationInitial extends AppNavigationState {
  const AppNavigationInitial({required super.tabIndex});
}

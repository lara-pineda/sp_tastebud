part of 'app_navigation_bloc.dart';

@immutable
abstract class AppNavigationEvent {}

class TabChange extends AppNavigationEvent {
  final int tabIndex;

  TabChange({required this.tabIndex});
}

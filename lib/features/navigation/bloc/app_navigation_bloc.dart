import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'app_navigation_event.dart';
part 'app_navigation_state.dart';

class AppNavigationBloc extends Bloc<AppNavigationEvent, AppNavigationState> {
  AppNavigationBloc() : super(const AppNavigationInitial(tabIndex: 0)) {
    on<AppNavigationEvent>((event, emit) {
      if (event is TabChange) {
        emit(AppNavigationInitial(tabIndex: event.tabIndex));
      }
    });
  }
}

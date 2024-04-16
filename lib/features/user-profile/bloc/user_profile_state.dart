part of 'user_profile_bloc.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final List<bool> dietaryPreferences;
  UserProfileLoaded(this.dietaryPreferences);
}

class UserProfileUpdated extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final String error;
  UserProfileError(this.error);
}

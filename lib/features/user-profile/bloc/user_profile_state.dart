part of 'user_profile_bloc.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final List dietaryPreferences;
  final List allergies;
  final List macronutrients;
  final List micronutrients;

  UserProfileLoaded(this.dietaryPreferences, this.allergies,
      this.macronutrients, this.micronutrients);
}

class UserProfileUpdated extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final String error;
  UserProfileError(this.error);
}

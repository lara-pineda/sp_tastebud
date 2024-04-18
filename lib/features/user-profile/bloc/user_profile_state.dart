part of 'user_profile_bloc.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final List<bool> dietaryPreferences;
  final List<bool> allergies;
  final List<bool> macronutrients;
  final List<bool> micronutrients;

  UserProfileLoaded(this.dietaryPreferences, this.allergies,
      this.macronutrients, this.micronutrients);
}

class UserProfileUpdated extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final String error;
  UserProfileError(this.error);
}

part of 'user_profile_bloc.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final List dietaryPreferences;
  final List allergies;
  final List macronutrients;
  final List micronutrients;
  final String? email;

  UserProfileLoaded(this.dietaryPreferences, this.allergies,
      this.macronutrients, this.micronutrients,
      [this.email]);
}

class UserProfileUpdated extends UserProfileState {
  late final List dietaryPreferences;
  late final List allergies;
  late final List macronutrients;
  late final List micronutrients;
  final String? email;

  UserProfileUpdated(this.dietaryPreferences, this.allergies,
      this.macronutrients, this.micronutrients,
      [this.email]);
}

class UserProfileError extends UserProfileState {
  final String error;
  UserProfileError(this.error);
}

class UserProfileChangeEmailError extends UserProfileState {
  final String error;
  UserProfileChangeEmailError(this.error);
}

class UserProfileEmailChanged extends UserProfileState {
  final String newEmail;

  UserProfileEmailChanged(this.newEmail);
}

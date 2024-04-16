part of 'user_profile_bloc.dart';

abstract class UserProfileEvent {}

class LoadUserProfile extends UserProfileEvent {}

class UpdateUserProfile extends UserProfileEvent {
  final List<String> selectedOptions;
  UpdateUserProfile(this.selectedOptions);
}

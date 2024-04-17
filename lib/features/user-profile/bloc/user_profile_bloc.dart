import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/features/user-profile/data/user_profile_repository.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository _userProfileRepository;

  UserProfileBloc(this._userProfileRepository) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  void _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(UserProfileError("User not logged in"));
      return;
    }

    try {
      var data = await _userProfileRepository.fetchUserProfile(userId);
      if (data != null && data.containsKey('dietaryPreferences')) {
        var preferences =
            List<bool>.from(data['dietaryPreferences'] as List<dynamic>);
        emit(UserProfileLoaded(preferences));
      } else {
        emit(UserProfileLoaded(
            List<bool>.filled(Options.dietaryPreferences.length, false)));
      }
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  void _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserProfileState> emit) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(UserProfileError("User not logged in"));
      return;
    }
    try {
      await _userProfileRepository.saveUserProfile(
          userId, event.selectedOptions);
      emit(UserProfileUpdated());
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}

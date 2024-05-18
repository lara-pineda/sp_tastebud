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
    on<ChangeEmail>(_onChangeEmail);
  }

  void _onChangeEmail(ChangeEmail event, Emitter<UserProfileState> emit) async {
    try {
      await _userProfileRepository.callChangeEmail(
          event.currentEmail, event.newEmail, event.password);

      // Update the state with the new email
      emit(UserProfileEmailChanged(event.newEmail));
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            emit(UserProfileChangeEmailError('No user found for that email.'));
            break;
          case 'wrong-password':
            emit(UserProfileChangeEmailError('Wrong password provided.'));
            break;
          default:
            emit(UserProfileChangeEmailError(
                'Failed to change email: ${e.message}'));
            break;
        }
      } else {
        emit(UserProfileChangeEmailError(e.toString()));
      }
    }
  }

  void _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    var userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userId == null) {
      emit(UserProfileError("User not logged in"));
      return;
    }

    try {
      var data = await _userProfileRepository.fetchUserProfile(userId);
      if (data != null) {
        var fetchDietPref = data['dietaryPreferences'] as List<dynamic>;
        var fetchAllergies = data['allergies'] as List<dynamic>;
        var fetchMacro = data['macronutrients'] as List<dynamic>;
        var fetchMicro = data['micronutrients'] as List<dynamic>;

        print("fetchDietPref: $fetchDietPref");
        print("fetchAllergies: $fetchAllergies");
        print("fetchMacro: $fetchMacro");
        print("fetchMicro: $fetchMicro");
        print("email: $userEmail");

        // Update state with the loaded profile data
        emit(UserProfileLoaded(
            fetchDietPref.cast<String>(),
            fetchAllergies.cast<String>(),
            fetchMacro.cast<String>(),
            fetchMicro.cast<String>(),
            userEmail));
      } else {
        // Return empty lists
        emit(UserProfileLoaded(
          [],
          [],
          [],
          [],
          '',
        ));
      }
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  void _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserProfileState> emit) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    var userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userId == null) {
      emit(UserProfileError("User not logged in"));
      return;
    }
    try {
      await _userProfileRepository.saveUserProfile(
          userId,
          event.selectedDietPref,
          event.selectedAllergies,
          event.selectedMacro,
          event.selectedMicro);

      // load again after updating to firestore
      emit(UserProfileUpdated(event.selectedDietPref, event.selectedAllergies,
          event.selectedMacro, event.selectedMicro, userEmail));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}

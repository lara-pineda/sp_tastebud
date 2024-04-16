import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final FirebaseFirestore _firestore;

  var userId = FirebaseAuth.instance.currentUser?.uid;

  UserProfileBloc(this._firestore) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  // Fetch user profile from Firestore and emit LoadedUserProfile state
  void _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    try {
      print("userId: ");
      print(userId);
      var snapshot = await _firestore.collection('users').doc(userId).get();
      var data = snapshot.data();

      if (data != null && data.containsKey('dietaryPreferences')) {
        // Ensure the data exists and is in the expected format.
        var preferences =
            List<bool>.from(data['dietaryPreferences'] as List<dynamic>);
        emit(UserProfileLoaded(preferences));
      } else {
        // Handle the case where dietaryPreferences does not exist or data is null
        emit(UserProfileLoaded(
            List<bool>.filled(Options.dietaryPreferences.length, false)));
      }
    } catch (e) {
      // Handle any errors that might occur during fetching or processing data
      emit(UserProfileError(e.toString()));
      // Depending on your implementation, you might want to log this error or show a user-friendly message.
    }
  }

  // Update user profile in Firestore and emit UserProfileUpdated state
  void _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserProfileState> emit) async {
    await _firestore.collection('users').doc(userId).update({
      'dietaryPreferences': event.selectedOptions,
    });
    emit(UserProfileUpdated());
  }
}

// Handling signup logic and state transitions based on user actions.

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/user_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _userRepository;

  SignupBloc(this._userRepository) : super(SignupInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      User user = await _userRepository.createUser(
          event.email, event.password); // CreateUser now returns User
      emit(SignupSuccess(user)); // Pass the user to the success state
    } on FirebaseAuthException catch (e) {
      emit(SignupFailure(e.message ?? "An unknown error occurred"));
    } catch (e) {
      emit(SignupFailure("An unknown error occurred"));
    }
  }
}

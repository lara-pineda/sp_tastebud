import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuth _firebaseAuth;

  SignupBloc(this._firebaseAuth) : super(SignupInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      emit(SignupSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(SignupFailure(e.message ?? "An unknown error occurred"));
    } catch (e) {
      emit(SignupFailure("An unknown error occurred"));
    }
  }
}

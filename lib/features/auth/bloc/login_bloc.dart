import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _firebaseAuth;

  LoginBloc(this._firebaseAuth) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      emit(LoginSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? "An unknown error occurred"));
    } catch (e) {
      emit(LoginFailure("An unknown error occurred"));
    }
  }
}

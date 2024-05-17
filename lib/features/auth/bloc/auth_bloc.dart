import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_tastebud/core/utils/user_not_found_exception.dart';
import '../data/preferences_service.dart';
import '../data/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  final PreferencesService _preferencesService;

  AuthBloc(this._userRepository, this._preferencesService)
      : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<CheckLoginStatus>(_onCheckLoginStatus);
    on<LogoutRequested>(_onLogoutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User user = await _userRepository.createUser(event.email, event.password);
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(AuthFailure('This email address is already in use.'));
      } else if (e.code == 'invalid-email') {
        emit(AuthFailure('Invalid email.'));
      } else {
        emit(AuthFailure("An unknown error occurred"));
      }
    } catch (e) {
      emit(AuthFailure("An unknown error occurred"));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User user = await _userRepository.signIn(event.email, event.password);
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-credential') {
        emit(AuthFailure('Incorrect email or password.'));
      } else if (e.code == 'invalid-email') {
        emit(AuthFailure('Invalid email.'));
      } else if (e.code == 'user-not-found') {
        emit(AuthFailure('User not found.'));
      } else if (e.code == 'too-many-requests') {
        emit(AuthFailure('Too many failed attempts. Try again later.'));
      } else {
        emit(AuthFailure("An unknown error occurred,"));
      }
    } catch (e) {
      emit(AuthFailure("An unknown error occurred"));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _userRepository.signOut();
      await _preferencesService
          .setRememberMe(false); // Clear remember me preference
      emit(AuthFailure("User not logged in."));
    } catch (e) {
      emit(AuthFailure("An unknown error occurred."));
    }
  }

  Future<void> _onPasswordResetRequested(
      PasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _userRepository.sendPasswordResetEmail(event.email);
      emit(AuthPasswordResetSuccess("Password reset email sent successfully."));
    } on UserNotFoundException catch (e) {
      emit(AuthEmailNotFound(e.message));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure("Failed to send password reset email: ${e.message}"));
    } catch (e) {
      emit(AuthFailure("An unknown error occurred.\nPlease try again later."));
    }
  }

  void _onCheckLoginStatus(CheckLoginStatus event, Emitter<AuthState> emit) {
    var user = _userRepository.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthFailure("User not logged in."));
    }
  }
}

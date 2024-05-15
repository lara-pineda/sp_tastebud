import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
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
      emit(AuthFailure("User not logged in"));
    } catch (e) {
      emit(AuthFailure("An unknown error occurred"));
    }
  }

  void _onCheckLoginStatus(CheckLoginStatus event, Emitter<AuthState> emit) {
    var user = _userRepository.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthFailure("User not logged in"));
    }
  }
// USAGE
// // Trigger another bloc with dependency injection for fetching user data
// context.read<AuthWrapperBloc>().add(CheckLoginStatus());

// REDIRECTION
// BlocListener<AuthWrapperBloc, AuthWrapperState>(
//   listener: (context, state) {
//     if (state is AuthWrapperError && state.message == "User not logged in") {
//       // Assuming you're using GoRouter or Navigator for routing
//       GoRouter.of(context).go('/main-menu');  // Redirect to main menu or login page
//     }
//   },
//   child: Container(), // Your UI elements here
// )
}

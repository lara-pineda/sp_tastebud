import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import '../data/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc(this._userRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<CheckLoginStatus>(_onCheckLoginStatus);
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User user = await _userRepository.createUser(event.email, event.password);
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "An unknown error occurred"));
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
      emit(AuthFailure(e.message ?? "An unknown error occurred"));
    } catch (e) {
      emit(AuthFailure("An unknown error occurred"));
    }
    // USAGE
    // context.read<LoginBloc>().add(CheckLoginStatus());

    // BlocBuilder<LoginBloc, LoginState>(
    //   builder: (context, state) {
    //     if (state is LoginSuccess) {
    //       return Text(state.message);  // "User is logged in"
    //     } else if (state is LoginFailure) {
    //       return Text(state.message);  // "User not logged in"
    //     }
    //     return CircularProgressIndicator();
    //   },
    // );
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

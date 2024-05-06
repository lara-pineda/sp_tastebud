import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_tastebud/features/auth/data/user_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc(this._userRepository) : super(LoginInitial()) {
    // Event handlers
    on<LoginRequested>(_onLoginRequested);
    on<CheckLoginStatus>(_onCheckLoginStatus);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      User user = await _userRepository.signIn(
        event.email,
        event.password,
      );

      emit(LoginSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? "An unknown error occurred"));
    } catch (e) {
      emit(LoginFailure("An unknown error occurred"));
    }
  }

  void _onCheckLoginStatus(CheckLoginStatus event, Emitter<LoginState> emit) {
    var user = _userRepository.getCurrentUser();
    if (user != null) {
      emit(LoginSuccess(user));
    } else {
      emit(LoginFailure("User not logged in"));
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

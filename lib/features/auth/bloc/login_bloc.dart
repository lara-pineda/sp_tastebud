import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sp_tastebud/features/auth/data/user_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc(this._userRepository) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
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
}

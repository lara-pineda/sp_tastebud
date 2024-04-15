part of 'signup_bloc.dart';

abstract class SignupEvent {}

class SignUpRequested extends SignupEvent {
  final String email;
  final String password;

  SignUpRequested({required this.email, required this.password});
}

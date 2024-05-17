part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AuthPasswordResetSuccess extends AuthState {
  final String message;

  const AuthPasswordResetSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AuthEmailNotFound extends AuthState {
  final String message;

  const AuthEmailNotFound(this.message);

  @override
  List<Object> get props => [message];
}

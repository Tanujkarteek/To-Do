part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({required this.message});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class AuthLogoutSuccess extends AuthState {
  final String message;

  AuthLogoutSuccess({required this.message});
}

class AuthLogoutError extends AuthState {
  final String message;

  AuthLogoutError({required this.message});
}

class AuthRegisterSuccess extends AuthState {
  final String message;

  AuthRegisterSuccess({required this.message});
}

class AuthRegisterError extends AuthState {
  final String message;

  AuthRegisterError({required this.message});
}

class AuthCheckSuccess extends AuthState {
  final String message;

  AuthCheckSuccess({required this.message});
}

class AuthCheckError extends AuthState {
  final String message;

  AuthCheckError({required this.message});
}
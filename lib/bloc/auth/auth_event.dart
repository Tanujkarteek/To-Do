part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

class AuthLogout extends AuthEvent {}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;
  AuthRegister(
      {required this.email, required this.password, required this.name});
}

class AuthCheck extends AuthEvent {}

class AuthDelete extends AuthEvent {}

class AuthRequested extends AuthEvent {}
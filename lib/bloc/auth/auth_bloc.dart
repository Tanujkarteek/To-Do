import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../appwrite/auth_api.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
final AuthAPI authAPI;
  AuthBloc(this.authAPI) : super(AuthInitial()) {
    on<AuthRegister>((event, emit) async {
      bool noException = true;
      try {
        await authAPI.createUser(
          email: event.email,
          password: event.password,
          name: event.name,
        );
      } on AppwriteException catch (e) {
        noException = false;
        emit(AuthRegisterError(message: e.toString()));
      } finally {
        if (noException) {
          emit(AuthRegisterSuccess(message: 'Registration successful'));
        }
      }
    });
    on<AuthLogin>((event, emit) async {
      bool noException = true;
      try {
          await authAPI.createEmailSession(
          email: event.email,
          password: event.password,
        );
      } on AppwriteException catch (e) {
        noException = false;
        emit(AuthError(message: e.toString()));
        return;
      } finally {
        if (noException) {
          print(authAPI.status);
          emit(AuthSuccess(message: 'Login successful'));
        }
      }
    });
    on<AuthLogout>((event, emit) async {
      bool noException = true;
      try {
         await authAPI.signOut();
      } on AppwriteException catch (e) {
        noException = false;
        emit(AuthLogoutError(message: e.toString()));
      } finally {
        if (noException) {
          emit(AuthLogoutSuccess(message: 'Logout successful'));
        }
      }
    });
  }
}
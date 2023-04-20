import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LoggedOutState());

  Future<void> login(Auth0 auth0) async {
    emit(LoggingInState());
    try {
      Credentials credentials = await auth0
          .webAuthentication(
            scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'],
          )
          .login(audience: dotenv.env['AUTH0_AUDIENCE']);

      emit(LoggedInState(credentials: credentials));
    } catch (e) {
      emit(LoggedOutState());
    }
  }

  Future<void> logout(Auth0 auth0) async {
    emit(LoggingInState());
    try {
      await auth0
          .webAuthentication(
            scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'],
          )
          .logout();
    } finally {
      emit(LoggedOutState());
    }
  }
}

abstract class AuthState {}

class LoggedInState extends AuthState {
  LoggedInState({required this.credentials});

  final Credentials credentials;
}

class LoggedOutState extends AuthState {
  LoggedOutState();
}

class LoggingInState extends AuthState {
  LoggingInState();
}

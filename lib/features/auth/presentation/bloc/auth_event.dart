part of 'auth_bloc.dart';

abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;
  SignInWithEmail({
    required this.email,
    required this.password,
  });
}

class SignUpWithEmail extends AuthEvent {
  final String email;
  final String password;
  SignUpWithEmail({
    required this.email,
    required this.password,
  });
}

class SignInWithGoogle extends AuthEvent {}

class SignOut extends AuthEvent {}

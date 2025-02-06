import 'package:todoist/core/utils/exceptions/base_exception.dart';

class AuthException extends BaseException {
  const AuthException(super.message);
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('No user found with this email');
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException() : super('Wrong password');
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException() : super('Invalid email format');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('Email already in use');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Password is too weak');
}

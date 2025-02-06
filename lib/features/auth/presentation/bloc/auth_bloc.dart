import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:todoist/features/auth/domain/entities/user_entity.dart';
import 'package:todoist/features/auth/domain/repo/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(AuthInitial()) {
    _repository.authStateChanges.listen(
      (user) {
        add(CheckAuthStatus());
      },
    );

    on<CheckAuthStatus>(
      (event, emit) async {
        final isSignedIn = await _repository.isSignedIn();
        if (isSignedIn) {
          final userId = await _repository.getUserId();
          emit(Authenticated(UserEntity(
            id: userId,
            isEmailVerified: false,
            email: null,
          )));
        } else {
          emit(Unauthenticated());
        }
      },
    );

    on<SignInWithEmail>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _repository.signInWithEmailAndPassword(
            event.email,
            event.password,
          );
        } on AuthException catch (e) {
          emit(AuthError(e.message));
        }
      },
    );

    on<SignUpWithEmail>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _repository.signUpWithEmailAndPassword(
            event.email,
            event.password,
          );
        } on AuthException catch (e) {
          emit(AuthError(e.message));
        }
      },
    );

    on<SignInWithGoogle>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _repository.signInWithGoogle();
        } on AuthException catch (e) {
          emit(AuthError(e.message));
        }
      },
    );

    on<SignOut>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _repository.signOut();
        } on AuthException catch (e) {
          emit(AuthError(e.message));
        }
      },
    );
  }
}

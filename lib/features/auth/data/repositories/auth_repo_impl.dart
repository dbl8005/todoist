import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoist/features/auth/domain/entities/user_entity.dart';
import 'package:todoist/features/auth/domain/repo/auth_repository.dart';

class AuthRepoImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepoImpl({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<UserEntity?> get authStateChanges {
    return _auth.authStateChanges().map(
      (firebaseUser) {
        return firebaseUser == null
            ? null
            : UserEntity(
                id: firebaseUser.uid,
                isEmailVerified: firebaseUser.emailVerified,
                email: firebaseUser.email,
              );
      },
    );
  }

  @override
  Future<String> getUserId() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw AuthException('User not found');
    }
    return user.uid;
  }

  @override
  Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw AuthException('Sign in aborted');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  AuthException _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException('User not found');
      case 'wrong-password':
        return AuthException('Wrong password');
      case 'email-already-in-use':
        return AuthException('Email already in use');
      case 'invalid-email':
        return AuthException('Invalid email');
      case 'operation-not-allowed':
        return AuthException('Operation not allowed');
      case 'weak-password':
        return AuthException('Weak password');
      default:
        return AuthException(e.message ?? 'Authentication error');
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

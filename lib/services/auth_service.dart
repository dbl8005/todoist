import 'package:todoist/providers/firebase_auth_provider.dart';

class AuthService {
  final _firebaseAuthProvider = FirebaseAuthProvider();

  Future<void> signInWithGoogle() async {
    await _firebaseAuthProvider.signInWithGoogle();
  }
}

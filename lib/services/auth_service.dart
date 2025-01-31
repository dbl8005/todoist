import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoist/providers/firebase_auth_provider.dart';

class AuthService {
  final _firebaseAuthProvider = FirebaseAuthProvider();

  Future<void> signInWithGoogle() async {
    await _firebaseAuthProvider.signInWithGoogle();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

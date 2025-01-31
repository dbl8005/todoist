import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoist/providers/firebase_auth_provider.dart';

class AuthService {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

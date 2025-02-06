import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

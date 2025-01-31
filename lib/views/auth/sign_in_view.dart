import 'package:flutter/material.dart';
import 'package:todoist/services/auth_service.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await AuthService().signInWithGoogle();
            },
            child: const Text('Sign in with Google')),
      ),
    );
  }
}

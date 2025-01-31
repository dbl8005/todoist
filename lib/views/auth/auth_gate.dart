import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:todoist/utils/secret/secret_constants.dart';
import 'package:todoist/views/auth/sign_in_view.dart';
import 'package:todoist/views/todo/todo_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
      GoogleProvider(clientId: SecretConstants.googleClientId),
    ]);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {}),
            ],
          );
        }

        return TodoView();
      },
    );
  }
}

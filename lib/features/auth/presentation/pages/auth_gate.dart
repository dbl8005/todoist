import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todoist/features/auth/presentation/pages/login_page.dart';
import 'package:todoist/features/todo/presentation/pages/todos/todos_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is Authenticated) {
          return const TodosPage();
        }
        return LoginPage();
      },
    );
  }
}

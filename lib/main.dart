import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoist/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:todoist/features/auth/domain/repo/auth_repository.dart';
import 'package:todoist/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todoist/features/auth/presentation/pages/auth_gate.dart';
import 'package:todoist/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todoist/features/todo/domain/repositories/todo_repository.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<TodoRepository>(
            create: (context) => TodoRepositoryImpl(
              firestore: FirebaseFirestore.instance,
              auth: FirebaseAuth.instance,
            ),
          ),
          RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepoImpl(
              auth: FirebaseAuth.instance,
              googleSignIn: GoogleSignIn(),
            ),
          )
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TodoBloc>(
              create: (context) => TodoBloc(
                repository: context.read<TodoRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) =>
                  AuthBloc(repository: context.read<AuthRepository>())
                    ..add(CheckAuthStatus()),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AuthGate(),
          ),
        ));
  }
}

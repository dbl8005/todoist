import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/core/configs/theme/theme.dart';
import 'package:todoist/core/configs/theme/theme_cubit.dart';
import 'package:todoist/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:todoist/features/auth/domain/repo/auth_repository.dart';
import 'package:todoist/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todoist/features/auth/presentation/pages/auth_gate.dart';
import 'package:todoist/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todoist/features/todo/domain/repositories/todo_repository.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final todoRepository = TodoRepositoryImpl();
  final authRepository = AuthRepoImpl(
    auth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
  );

  // Create AuthBloc instance first
  final authBloc = AuthBloc(repository: authRepository)..add(CheckAuthStatus());

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: todoRepository),
      RepositoryProvider.value(value: authRepository),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(prefs)),
        BlocProvider.value(value: authBloc), // Use value provider instead
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(repository: todoRepository),
        ),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const AuthGate(),
        );
      },
    );
  }
}

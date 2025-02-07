import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/core/configs/theme/theme_cubit.dart';
import 'package:todoist/core/utils/helpers/dialogs/confirm_dialog.dart';
import 'package:todoist/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todoist/features/todo/presentation/pages/todos/add_todo_page.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todoist/features/todo/presentation/widgets/todos/todo_list.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Add LoadTodos event when page is built
    context.read<TodoBloc>().add(LoadTodos());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Todos'),
        actions: [
          BlocBuilder<ThemeCubit, bool>(
            // Only rebuild the theme icon
            builder: (context, isDark) => IconButton(
              icon: Icon(isDark ? Icons.dark_mode_outlined : Icons.sunny),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showConfirmDialog(
                  context: context,
                  content: 'Are you sure you want to sign out?');
              if (confirmed == true && context.mounted) {
                context.read<AuthBloc>().add(SignOut());
              }
            },
          ),
        ],
      ),
      body: const TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTodoPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

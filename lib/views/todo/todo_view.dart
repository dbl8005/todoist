import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/databases/firestore_database.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/services/auth_service.dart';
import 'package:todoist/views/todo/new_todo_view.dart';
import 'package:todoist/views/widgets/todo_tile_widget.dart';

class TodoView extends ConsumerStatefulWidget {
  const TodoView({super.key});

  @override
  ConsumerState<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends ConsumerState<TodoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoist'),
        actions: [
          // log out
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthService().signOut();
              }),
          // button to add a new todo
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewTodoView(),
                  ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: StreamBuilder(
          stream: FirestoreDatabase().getTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final todos = snapshot.data ?? [];
            todos.sort((a, b) {
              if (a.isCompleted == b.isCompleted) {
                return 0;
              }
              return a.isCompleted ? 1 : -1;
            });

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoTileWidget(todo: todo);
              },
            );
          },
        ),
      ),
    );
  }
}

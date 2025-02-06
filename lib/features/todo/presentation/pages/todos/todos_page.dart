import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/features/todo/domain/repositories/todo_repository.dart';
import 'package:todoist/features/todo/presentation/pages/todos/add_todo_page.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todoist/features/todo/presentation/widgets/todos/todo_list.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Todos'),
      ),
      body: TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTodoPage(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

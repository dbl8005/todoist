import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todoist/features/todo/presentation/widgets/todos/todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TodoError) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is TodoLoaded && state.todos.isEmpty) {
          return Center(
            child: Text('No todos yet'),
          );
        }
        if (state is TodoLoaded) {
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return TodoItem(
                todo: todo,
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

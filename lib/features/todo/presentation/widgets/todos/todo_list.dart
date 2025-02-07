import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/features/todo/domain/entities/todo_entity.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todoist/features/todo/presentation/widgets/todos/todo_item.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';

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
          List<TodoEntity> sortedTodos = [...state.todos]
            ..sort((a, b) => a.isCompleted == b.isCompleted
                ? 0
                : a.isCompleted
                    ? 1
                    : -1);
          return AnimatedListView(
            items: sortedTodos,
            enterTransition: [
              FadeIn(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              ),
              ScaleIn(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              )
            ],
            exitTransition: [
              SlideInUp(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              )
            ],
            isSameItem: (a, b) => a.id == b.id,
            itemBuilder: (context, index) {
              final todo = sortedTodos[index];
              return TodoItem(
                key: ValueKey(todo.id),
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

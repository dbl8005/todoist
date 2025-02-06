import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/features/todo/domain/entities/todo_entity.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';

class TodoItem extends StatefulWidget {
  final TodoEntity todo;
  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    // We should use BlocBuilder here to react to state changes
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoaded) {
          // Get the latest version of this todo from state
          final currentTodo = state.todos.firstWhere(
            (t) => t.id == widget.todo.id,
            orElse: () => widget.todo,
          );

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                currentTodo.title,
                style: TextStyle(
                  decoration: currentTodo.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Text(currentTodo.description),
              leading: Checkbox(
                value: currentTodo.isCompleted,
                onChanged: (_) => context.read<TodoBloc>().add(
                      ToggleTodo(currentTodo.id),
                    ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => context.read<TodoBloc>().add(
                      DeleteTodo(currentTodo.id),
                    ),
              ),
              onTap: () => _showSubtasks(context, currentTodo),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _showSubtasks(BuildContext context, TodoEntity todo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            final currentTodo = state.todos.firstWhere(
              (t) => t.id == todo.id,
              orElse: () => todo,
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Subtasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: currentTodo.subtasks.length == 0
                      ? Center(
                          child: Text('No subtasks yet'),
                        )
                      : ListView.builder(
                          itemCount: currentTodo.subtasks.length,
                          itemBuilder: (context, index) {
                            final sortedSubtasks = [...currentTodo.subtasks]
                              ..sort(
                                (a, b) => a.isCompleted == b.isCompleted
                                    ? 0
                                    : a.isCompleted
                                        ? 1
                                        : -1,
                              );
                            final subtask = sortedSubtasks[index];
                            return CheckboxListTile(
                              value: subtask.isCompleted,
                              title: Text(
                                subtask.title,
                              ),
                              onChanged: (_) => context.read<TodoBloc>().add(
                                    ToggleSubtask(
                                      todoId: currentTodo.id,
                                      subtaskId: subtask.id,
                                    ),
                                  ),
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

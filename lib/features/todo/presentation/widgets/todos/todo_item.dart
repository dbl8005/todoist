import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/core/utils/helpers/dialogs/confirm_dialog.dart';
import 'package:todoist/features/todo/domain/entities/todo_entity.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoItem extends StatefulWidget {
  final TodoEntity todo;
  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoaded) {
          final currentTodo = state.todos.firstWhere(
            (t) => t.id == widget.todo.id,
            orElse: () => widget.todo,
          );

          final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
          final textColor = isDarkTheme ? Colors.white : Colors.black;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Opacity(
              opacity: currentTodo.isCompleted ? 0.5 : 1,
              child: Slidable(
                key: ValueKey(currentTodo.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: Colors.red,
                      onPressed: (context) async {
                        final bloc = context.read<TodoBloc>();
                        final confirmed = await showConfirmDialog(
                          context: context,
                          content: 'Are you sure you want to delete this todo?',
                        );
                        if (confirmed == true) {
                          bloc.add(DeleteTodo(currentTodo.id));
                        }
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: currentTodo.isCompleted
                        ? Colors.grey[800]
                        : Theme.of(context).cardColor,
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      currentTodo.title,
                      style: TextStyle(color: textColor),
                    ),
                    subtitle: Text(
                      currentTodo.description,
                      style: TextStyle(color: textColor),
                    ),
                    leading: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: currentTodo.isCompleted ? 1.1 : 1,
                      child: Checkbox(
                        activeColor: Colors.green,
                        value: currentTodo.isCompleted,
                        onChanged: (_) => context.read<TodoBloc>().add(
                              ToggleTodo(currentTodo.id),
                            ),
                      ),
                    ),
                    onTap: () => _showSubtasks(context, currentTodo),
                  ),
                ),
              ),
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

            final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
            final textColor = isDarkTheme ? Colors.white : Colors.black;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Subtasks',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: textColor),
                  ),
                ),
                Expanded(
                  child: currentTodo.subtasks.isEmpty
                      ? Center(
                          child: Text(
                            'No subtasks yet',
                            style: TextStyle(color: textColor),
                          ),
                        )
                      : AnimatedListView(
                          enterTransition: [
                            FadeIn(duration: const Duration(milliseconds: 200)),
                            SlideInLeft(
                                duration: const Duration(milliseconds: 200))
                          ],
                          isSameItem: (a, b) => a.id == b.id,
                          items: currentTodo.subtasks,
                          itemBuilder: (context, index) {
                            final subtask = currentTodo.subtasks[index];
                            return CheckboxListTile(
                              key: ValueKey(subtask.id),
                              value: subtask.isCompleted,
                              title: Text(
                                subtask.title,
                                style: TextStyle(color: textColor),
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

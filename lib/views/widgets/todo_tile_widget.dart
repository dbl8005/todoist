import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/providers/todo_list_provider.dart';
import 'package:todoist/services/todo_service.dart';
import 'package:todoist/utils/helpers/dialogs/confirm_dialog.dart';
import 'package:todoist/utils/helpers/dialogs/info_dialog.dart';

class TodoTileWidget extends ConsumerWidget {
  const TodoTileWidget({
    super.key,
    required this.todo,
  });

  final TodoModel todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoService = TodoService(ref);
    return Card(
      color: todo.isCompleted ? Colors.lightGreen : Theme.of(context).cardColor,
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            todoService.toggleTodo(todo.id);
          },
        ),
        title: Text(todo.title),
        subtitle: Text(
          todo.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // button to expand the card and show the description
            IconButton(
                onPressed: () =>
                    todoService.showInfo(context: context, todo: todo),
                icon: const Icon(Icons.expand_more_rounded)),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => todoService.removeTodo(context, todo.id),
            ),
          ],
        ),
      ),
    );
  }
}

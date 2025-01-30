import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/providers/todo_list_provider.dart';
import 'package:todoist/utils/dialogs/confirm_dialog.dart';
import 'package:todoist/utils/dialogs/info_dialog.dart';

class TodoTileWidget extends ConsumerWidget {
  const TodoTileWidget({
    super.key,
    required this.todo,
  });

  final TodoModel todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: todo.isCompleted ? Colors.lightGreen : Theme.of(context).cardColor,
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            ref.read(todoListProvider.notifier).toggleTodo(todo.id);
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
                onPressed: () {
                  showInfoDialog(
                      context: context,
                      title: todo.title,
                      description: todo.description);
                },
                icon: const Icon(Icons.expand_more_rounded)),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showConfirmDialog(
                        context: context,
                        content: 'Are you sure you want to delete this todo?')
                    .then((value) => value!
                        ? ref
                            .read(todoListProvider.notifier)
                            .removeTodo(todo.id)
                        : null);
              },
            ),
          ],
        ),
      ),
    );
  }
}

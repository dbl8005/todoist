import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/providers/todo_list_provider.dart';
import 'package:todoist/utils/helpers/dialogs/confirm_dialog.dart';
import 'package:todoist/utils/helpers/dialogs/info_dialog.dart';

class TodoService {
  final WidgetRef ref;

  TodoService(this.ref);

  void toggleTodo(String id) =>
      ref.read(todoListProvider.notifier).toggleTodo(id);

  void removeTodo(BuildContext context, String id) async {
    await showConfirmDialog(
            context: context,
            content: 'Are you sure you want to delete this todo?')
        .then((value) =>
            value! ? ref.read(todoListProvider.notifier).removeTodo(id) : null);
  }

  void addTodo(String title, String description) =>
      ref.read(todoListProvider.notifier).addTodo(title, description);

  Future<void> showInfo({
    required BuildContext context,
    required TodoModel todo,
  }) async {
    await showInfoDialog(
      context: context,
      title: todo.title,
      description: todo.description,
    );
  }

  final todoServiceProvider = Provider((ref) => TodoService(ref as WidgetRef));
}

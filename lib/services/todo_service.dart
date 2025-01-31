import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/databases/firestore_database.dart';
import 'package:todoist/models/subtask_model.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/utils/helpers/dialogs/confirm_dialog.dart';
import 'package:todoist/utils/helpers/dialogs/info_dialog.dart';

class TodoService {
  final WidgetRef ref;

  TodoService(this.ref);

  FirestoreDatabase firestoreDb = FirestoreDatabase();

  Future<void> toggleTodo(String id) => firestoreDb.toggleTodo(id);

  Future<void> removeTodo(BuildContext context, String id) async {
    await showConfirmDialog(
            context: context,
            content: 'Are you sure you want to delete this todo?')
        .then(
      (value) async {
        if (value ?? false) {
          await firestoreDb.deleteTodo(id);
        }
        return;
      },
    );
  }

  Future<void> addTodo(
      String title, String description, List<Subtask> subtasks) async {
    await firestoreDb.addTodo(title, description, subtasks);
  }

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

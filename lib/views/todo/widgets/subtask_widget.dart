import 'package:flutter/material.dart';
import 'package:todoist/models/subtask_model.dart';
import 'package:todoist/services/todo_service.dart';

class SubtaskWidget extends StatelessWidget {
  const SubtaskWidget({super.key, required this.subtask, required this.todoId});
  final Subtask subtask;
  final String todoId;

  @override
  Widget build(BuildContext context) {
    final todoService = TodoService();
    return Row(
      children: [
        Checkbox(
          value: subtask.isCompleted,
          onChanged: (value) {
            todoService.toggleSubtask(todoId, subtask.id);
          },
        ),
        Text(
          subtask.title,
        ),
      ],
    );
  }
}

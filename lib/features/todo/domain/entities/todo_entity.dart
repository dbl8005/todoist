import 'package:todoist/features/todo/domain/entities/subtask_entity.dart';

class TodoEntity {
  final String id;
  final String title;
  final String description;
  final List<SubtaskEntity> subtasks;
  final bool isCompleted;

  const TodoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.subtasks,
    required this.isCompleted,
  });
}

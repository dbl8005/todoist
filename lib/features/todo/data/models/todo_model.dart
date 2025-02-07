import 'package:todoist/features/todo/domain/entities/todo_entity.dart';
import 'package:todoist/features/todo/data/models/subtask_model.dart';

class TodoModel extends TodoEntity {
  TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required List<SubtaskModel> super.subtasks,
    required super.isCompleted,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    List<SubtaskModel>? subtasks,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subtasks: subtasks ?? (this.subtasks as List<SubtaskModel>),
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subtasks': subtasks.map((x) => (x as SubtaskModel).toMap()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    return TodoModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      subtasks: (map['subtasks'] as List<dynamic>?)
              ?.map((x) => SubtaskModel.fromMap(x))
              .toList() ??
          [],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

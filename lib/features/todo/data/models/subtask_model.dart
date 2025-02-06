import 'package:todoist/features/todo/domain/entities/subtask_entity.dart';

class SubtaskModel extends SubtaskEntity {
  SubtaskModel({
    required String id,
    required String title,
    required bool isCompleted,
  }) : super(
          id: id,
          title: title,
          isCompleted: isCompleted,
        );

  // Create copy with optional changes
  SubtaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Create from Firebase data
  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

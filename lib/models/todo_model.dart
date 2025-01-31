// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:todoist/models/subtask_model.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final List<Subtask> subtasks;
  final bool isCompleted;
  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subtasks,
    required this.isCompleted,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    List<Subtask>? subtasks,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subtasks: subtasks ?? this.subtasks,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'subtasks': subtasks.map((x) => x.toMap()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      subtasks: map['subtasks'] != null
          ? List<Subtask>.from(
              (map['subtasks'] as List<dynamic>).map<Subtask>(
                (x) => Subtask.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [], // ✅ Default to empty list if subtasks is null
      isCompleted: map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, description: $description, subtasks: $subtasks, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.subtasks, subtasks) &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        subtasks.hashCode ^
        isCompleted.hashCode;
  }
}

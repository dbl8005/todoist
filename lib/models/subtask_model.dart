import 'dart:convert';

class Subtask {
  final String id;
  final String title;
  final bool isCompleted;

  Subtask({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  Subtask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map['id'] as String? ?? '', // ✅ Prevents null values
      title: map['title'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false, // ✅ Ensures a boolean
    );
  }

  String toJson() => json.encode(toMap());

  factory Subtask.fromJson(String source) =>
      Subtask.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Subtask(id: $id, title: $title, isCompleted: $isCompleted)';

  @override
  bool operator ==(covariant Subtask other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isCompleted.hashCode;
}

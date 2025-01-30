class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] == 1 ? true : false,
    );
  }
}

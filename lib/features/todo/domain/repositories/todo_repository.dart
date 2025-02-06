import 'package:todoist/features/todo/domain/entities/todo_entity.dart';

abstract class TodoRepository {
  Stream<List<TodoEntity>> getTodos();
  Future<void> addTodo(TodoEntity todo);
  Future<void> deleteTodo(String id);
  Future<void> toggleTodo(String id);
  Future<void> toggleSubtask(String todoId, String subtaskId);
}

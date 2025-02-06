part of 'todo_bloc.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final TodoEntity todo;
  AddTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
}

class ToggleTodo extends TodoEvent {
  final String id;
  ToggleTodo(this.id);
}

class ToggleSubtask extends TodoEvent {
  final String todoId;
  final String subtaskId;
  ToggleSubtask({required this.todoId, required this.subtaskId});
}

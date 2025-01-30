import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:todoist/providers/todo_list_provider.dart';

class TodoService {
  static final _reader = ProviderContainer().read;
  static addTodo(TodoModel todo) =>
      _reader(todoListProvider.notifier).addTodo(todo.title, todo.description);
  static toggleTodo(String id) =>
      _reader(todoListProvider.notifier).toggleTodo(id);
  static removeTodo(String id) =>
      _reader(todoListProvider.notifier).removeTodo(id);
}

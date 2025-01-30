import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/databases/todo_db.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

final todoListProvider = StateNotifierProvider<TodoNotifier, List<TodoModel>>(
  (ref) {
    return TodoNotifier();
  },
);

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  TodoNotifier() : super([]) {
    loadTodos();
  }

  final _db = TodoDatabase.instance;

  Future<void> loadTodos() async {
    final todos = await _db.getTodos();
    state = todos;
  }

  Future<void> addTodo(String title, String description) async {
    final newTodo = TodoModel(
      id: uuid.v4(),
      title: title,
      description: description,
      isCompleted: false,
    );
    state = [...state, newTodo];

    await _db.insertTodo(newTodo);

    sortTodosByCompletion();
  }

  Future<void> removeTodo(String id) async {
    state = state.where((element) => element.id != id).toList();

    await _db.deleteTodo(id);

    sortTodosByCompletion();
  }

  Future<void> toggleTodo(String id) async {
    state = state.map((todo) {
      if (todo.id == id) {
        final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
        _db.updateTodo(updatedTodo);
        return updatedTodo;
      }
      return todo;
    }).toList();
  }

  void sortTodosByCompletion() {
    // sort the list by completion status
    state.sort((a, b) {
      if (a.isCompleted && !b.isCompleted) {
        return 1;
      } else if (!a.isCompleted && b.isCompleted) {
        return -1;
      } else {
        return 0;
      }
    });
  }
}

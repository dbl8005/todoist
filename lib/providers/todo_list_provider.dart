import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

final todoListProvider = StateNotifierProvider<TodoNotifier, List<TodoModel>>(
  (ref) => TodoNotifier([]),
);

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  TodoNotifier(super.state);

  void addTodo(String title, String description) {
    final newTodo = TodoModel(
      id: uuid.v4(),
      title: title,
      description: description,
      isCompleted: false,
    );
    state = [...state, newTodo];

    sortTodosByCompletion();
  }

  void removeTodo(String id) {
    state = state.where((element) => element.id != id).toList();

    sortTodosByCompletion();
  }

  void toggleTodo(String id) {
    state = state.map((element) {
      if (element.id == id) {
        return element.copyWith(isCompleted: !element.isCompleted);
      }
      return element;
    }).toList();

    sortTodosByCompletion();
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

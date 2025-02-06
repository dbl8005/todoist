import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todoist/features/todo/data/models/subtask_model.dart';
import 'package:todoist/features/todo/data/models/todo_model.dart';
import 'package:todoist/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todoist/features/todo/domain/entities/todo_entity.dart';
import 'package:todoist/features/todo/domain/repositories/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _repository;

  TodoBloc({required TodoRepository repository})
      : _repository = repository,
        super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<ToggleSubtask>(_onToggleSubtask);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    await emit.forEach(
      _repository.getTodos(),
      onData: (List<TodoEntity> todos) => TodoLoaded(todos: todos),
      onError: (error, stackTrace) =>
          TodoError(message: _mapErrorToMessage(error)),
    );
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await _repository.addTodo(event.todo);
    } catch (e) {
      emit(TodoError(message: _mapErrorToMessage(e)));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await _repository.deleteTodo(event.id);
    } catch (e) {
      emit(TodoError(message: _mapErrorToMessage(e)));
    }
  }

  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    try {
      await _repository.toggleTodo(event.id);
    } catch (e) {
      emit(TodoError(message: _mapErrorToMessage(e)));
    }
  }

  Future<void> _onToggleSubtask(
      ToggleSubtask event, Emitter<TodoState> emit) async {
    try {
      if (state is TodoLoaded) {
        final currentState = state as TodoLoaded;

        // Optimistically update the state
        final updatedTodos = currentState.todos.map((todo) {
          if (todo.id == event.todoId) {
            final updatedSubtasks = todo.subtasks.map((subtask) {
              if (subtask.id == event.subtaskId) {
                return (subtask as SubtaskModel)
                    .copyWith(isCompleted: !subtask.isCompleted);
              }
              return subtask;
            }).toList();

            return (todo as TodoModel)
                .copyWith(subtasks: updatedSubtasks.cast<SubtaskModel>());
          }
          return todo;
        }).toList();

        // Emit optimistic update immediately
        emit(TodoLoaded(todos: updatedTodos));

        // Perform actual update
        await _repository.toggleSubtask(event.todoId, event.subtaskId);
      }
    } catch (e) {
      // On error, revert to original state by reloading
      emit(TodoLoading());
      await emit.forEach(
        _repository.getTodos(),
        onData: (todos) => TodoLoaded(todos: todos),
      );
      emit(TodoError(message: _mapErrorToMessage(e)));
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is UnauthorizedException) return 'Please sign in to continue';
    if (error is TodoNotFoundException) return 'Todo not found';
    return 'An error occured.';
  }
}

import 'package:todoist/core/utils/exceptions/base_exception.dart';

class TodoException extends BaseException {
  const TodoException(super.message);
}

class TodoNotFoundException extends TodoException {
  const TodoNotFoundException() : super('Todo not found');
}

class SubtaskNotFoundException extends TodoException {
  const SubtaskNotFoundException() : super('Subtask not found');
}

class UnauthorizedTodoException extends TodoException {
  const UnauthorizedTodoException() : super('Unauthorized to access this todo');
}

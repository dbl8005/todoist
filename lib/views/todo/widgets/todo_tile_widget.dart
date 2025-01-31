import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/models/subtask_model.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/services/todo_service.dart';
import 'package:todoist/utils/helpers/dialogs/confirm_dialog.dart';
import 'package:todoist/utils/helpers/dialogs/info_dialog.dart';
import 'package:todoist/views/todo/widgets/subtask_widget.dart';

class TodoTileWidget extends ConsumerWidget {
  const TodoTileWidget({
    super.key,
    required this.todo,
  });

  final TodoModel todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoService = TodoService();
    final List<Subtask> subtasks = todo.subtasks;
    return Card(
      color: todo.isCompleted ? Colors.grey : Theme.of(context).cardColor,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            todoService.toggleTodo(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          todo.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => todoService.removeTodo(context, todo.id),
        ),
        children: [
          Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subtasks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
                if (subtasks.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'No subtasks',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                StreamBuilder<List<Subtask>>(
                  stream: todoService.getSubtasks(todo.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final subtasks = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: subtasks.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Checkbox(
                          value: subtasks[index].isCompleted,
                          onChanged: (value) {
                            todoService.toggleSubtask(
                                todo.id, subtasks[index].id);
                          },
                        ),
                        title: Text(subtasks[index].title),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => todoService.removeSubtask(
                              todo.id, subtasks[index].id),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

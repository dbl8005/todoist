import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/models/subtask_model.dart';
import 'package:todoist/providers/todo_list_provider.dart';
import 'package:todoist/services/todo_service.dart';
import 'package:todoist/utils/helpers/snackbars/warning_snackbar.dart';

class NewTodoView extends ConsumerStatefulWidget {
  const NewTodoView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewTodoViewState();
}

class _NewTodoViewState extends ConsumerState<NewTodoView> {
  // Text Controllers
  List<TextEditingController> subtaskControllers = [];
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    subtaskControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoService = TodoService(ref);

    // functions
    void addSubtask() {
      // if last subtask is empty don't add another
      if (subtaskControllers.isNotEmpty &&
          subtaskControllers.last.text.isEmpty) {
        return;
      }
      setState(() {
        subtaskControllers.add(TextEditingController());
      });
    }

    void removeSubtask(int index) {
      setState(() {
        subtaskControllers.removeAt(index);
      });
    }

    void submit(BuildContext context) async {
      // check if title is empty
      if (titleController.text.isEmpty) {
        WarningSnackbar.show(
          context: context,
          message: 'Title cannot be empty',
        );
        return;
      }
      // turn subtasks into list of subtasks
      List<Subtask> subtasks = subtaskControllers
          .where((controller) => controller.text.isNotEmpty)
          .map(
            (controller) => Subtask(
              id: '',
              title: controller.text,
              isCompleted: false,
            ),
          )
          .toList();
      // add todo from service
      todoService.addTodo(
        titleController.text,
        descriptionController.text,
        subtasks,
      );
      log('title: ${titleController.text}');
      log('description: ${descriptionController.text}');
      log('subtasks: $subtasks');

      titleController.clear();
      descriptionController.clear();
      subtaskControllers.forEach((controller) => controller.clear());

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          // Field for title
          TextField(
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            controller: titleController,
          ),
          SizedBox(height: 16),
          // Field for description
          TextField(
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            controller: descriptionController,
            maxLines: null,
          ),
          SizedBox(height: 16),
          // subtask fields by count
          ListView.builder(
            shrinkWrap: true,
            itemCount: subtaskControllers.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  TextField(
                    controller: subtaskControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Subtask ${index + 1}',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              );
            },
          ),
          // button to add subtask field
          ElevatedButton(
            onPressed: () {
              addSubtask();
            },
            child: Text('Add Subtask'),
          ),

          // submit button
          ElevatedButton(
            onPressed: () => submit(context),
            child: Text('Submit'),
          ),
        ]),
      ),
    );
  }
}

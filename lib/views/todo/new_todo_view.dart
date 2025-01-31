import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoist/providers/todo_list_provider.dart';
import 'package:todoist/services/todo_service.dart';

class NewTodoView extends ConsumerWidget {
  const NewTodoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoService = TodoService(ref);
    // Text Controllers
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
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
          // submit button
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  descriptionController.text.isEmpty) {
                print("empty");
                return;
              }
              todoService.addTodo(
                titleController.text,
                descriptionController.text,
              );
              print(titleController.text + descriptionController.text);
              titleController.clear();
              descriptionController.clear();

              Navigator.pop(context);
            },
            child: Text('Submit'),
          ),
        ]),
      ),
    );
  }
}

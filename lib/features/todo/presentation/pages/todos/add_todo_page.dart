import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoist/features/todo/data/models/subtask_model.dart';
import 'package:todoist/features/todo/data/models/todo_model.dart';
import 'package:todoist/features/todo/domain/entities/subtask_entity.dart';
import 'package:todoist/features/todo/domain/entities/todo_entity.dart';
import 'package:todoist/features/todo/presentation/bloc/todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<TextEditingController> _subtaskControllers = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSubtaskField() {
    setState(() {
      _subtaskControllers.add(TextEditingController());
    });
  }

  void _removeSubtaskField(int index) {
    setState(() {
      _subtaskControllers[index].dispose();
      _subtaskControllers.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final todo = TodoModel(
        id: '', // Will be set by Firestore
        title: _titleController.text,
        description: _descriptionController.text,
        subtasks: _subtaskControllers
            .where((controller) => controller.text.isNotEmpty)
            .map((controller) => SubtaskModel(
                  id: '', // Will be set by Firestore
                  title: controller.text,
                  isCompleted: false,
                ))
            .toList(),
        isCompleted: false,
      );

      context.read<TodoBloc>().add(AddTodo(todo));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Text('Subtasks', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._subtaskControllers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: entry.value,
                        decoration: const InputDecoration(
                          labelText: 'Subtask',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeSubtaskField(entry.key),
                    ),
                  ],
                ),
              );
            }).toList(),
            TextButton.icon(
              onPressed: _addSubtaskField,
              icon: const Icon(Icons.add),
              label: const Text('Add Subtask'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Save Todo'),
            ),
          ],
        ),
      ),
    );
  }
}

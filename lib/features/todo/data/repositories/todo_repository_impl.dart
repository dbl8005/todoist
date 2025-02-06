import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoist/features/todo/data/models/subtask_model.dart';
import 'package:todoist/features/todo/data/models/todo_model.dart';
import 'package:todoist/features/todo/domain/entities/todo_entity.dart';
import 'package:todoist/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final String usersCollection = 'users';
  final String todosCollection = 'todos';

  TodoRepositoryImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _getTodosCollection() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw UnauthorizedException();
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(todosCollection);
  }

  @override
  Future<void> addTodo(TodoEntity todo) async {
    try {
      final todoModel = todo as TodoModel;

      // First create todo document without subtasks
      final todoRef = await _getTodosCollection().add({
        'id': '',
        'title': todoModel.title,
        'description': todoModel.description,
        'isCompleted': todoModel.isCompleted,
      });
      await todoRef.update({'id': todoRef.id});

      // Then add each subtask to subcollection
      final subtasksCollection = todoRef.collection('subtasks');
      for (final subtask in todoModel.subtasks) {
        final subtaskRef = await subtasksCollection.add({
          'id': '',
          'title': subtask.title,
          'isCompleted': subtask.isCompleted,
        });
        await subtaskRef.update({'id': subtaskRef.id});
      }
    } catch (e) {
      print('Error adding todo: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _getTodosCollection().doc(id).delete();
  }

  @override
  Stream<List<TodoEntity>> getTodos() {
    return _getTodosCollection().snapshots().asyncMap((todoSnapshot) async {
      List<TodoEntity> todos = [];

      for (var todoDoc in todoSnapshot.docs) {
        // Get subtasks
        final subtasksSnapshot =
            await todoDoc.reference.collection('subtasks').get();

        final subtasks = subtasksSnapshot.docs
            .map((subtaskDoc) => SubtaskModel(
                  id: subtaskDoc.id,
                  title: subtaskDoc.data()['title'] ?? '',
                  isCompleted: subtaskDoc.data()['isCompleted'] ?? false,
                ))
            .toList();

        // Create todo with its subtasks
        todos.add(TodoModel.fromMap(todoDoc.data(), todoDoc.id)
            .copyWith(subtasks: subtasks));
      }

      return todos;
    });
  }

  @override
  Future<void> toggleSubtask(String todoId, String subtaskId) async {
    try {
      print('Toggling subtask: $todoId, $subtaskId'); // Debug
      final subtaskRef = _getTodosCollection()
          .doc(todoId)
          .collection('subtasks')
          .doc(subtaskId);

      await _firestore.runTransaction((transaction) async {
        final subtaskSnap = await transaction.get(subtaskRef);
        print('Current subtask state: ${subtaskSnap.data()}'); // Debug
        if (!subtaskSnap.exists) throw SubtaskNotFoundException();

        transaction.update(subtaskRef,
            {'isCompleted': !(subtaskSnap.data()?['isCompleted'] ?? false)});
      });
    } catch (e) {
      print('Toggle subtask error: $e'); // Debug
      rethrow;
    }
  }

  @override
  Future<void> toggleTodo(String id) async {
    final todoRef = _getTodosCollection().doc(id);
    await _firestore.runTransaction(
      (transaction) async {
        final todoSnap = await transaction.get(todoRef);
        if (!todoSnap.exists) {
          throw TodoNotFoundException();
        }
        final currentTodo = TodoModel.fromMap(todoSnap.data()!, todoSnap.id);
        transaction.update(todoRef, {'isCompleted': !currentTodo.isCompleted});
      },
    );
  }
}

class UnauthorizedException implements Exception {}

class TodoNotFoundException implements Exception {}

class SubtaskNotFoundException implements Exception {}

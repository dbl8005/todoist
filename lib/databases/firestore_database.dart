import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoist/models/subtask_model.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/utils/constants/firestore_constants.dart';

class FirestoreDatabase {
  FirestoreDatabase();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // get all todos for current user
  Stream<List<TodoModel>> getTodos() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
          code: 'user-not-signed-in', message: 'User is not signed in.');
    }
    final userId = user.uid;
    final todos = firestore
        .collection(FirestoreConstants.userCollection)
        .doc(userId)
        .collection(FirestoreConstants.todosCollection)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TodoModel.fromMap(doc.data())).toList());

    return todos;
  }

  Future<void> addTodo(
      String title, String description, List<Subtask> subtasks) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'user-not-signed-in', message: 'User is not signed in.');
      }
      final userId = user.uid;

      // reference individual user collection todos
      CollectionReference userTodosRef = firestore
          .collection(FirestoreConstants.userCollection)
          .doc(userId)
          .collection(FirestoreConstants.todosCollection);

      // Add main task
      DocumentReference taskRef = await userTodosRef.add({
        FirestoreConstants.idColumn: '',
        FirestoreConstants.addedByColumn: userId,
        FirestoreConstants.titleColumn: title,
        FirestoreConstants.descriptionColumn: description,
        FirestoreConstants.isCompletedColumn: false,
      });
      // Update main task id
      await taskRef.update({FirestoreConstants.idColumn: taskRef.id});

      // Add subtasks for this task
      for (Subtask subtask in subtasks) {
        DocumentReference subtaskRef = await taskRef
            .collection(FirestoreConstants.subtasksCollection)
            .add({
          FirestoreConstants.idColumn: '',
          FirestoreConstants.titleColumn: subtask.title,
          FirestoreConstants.isCompletedColumn: subtask.isCompleted,
        });
        // Update subtask ID
        await subtaskRef.update({FirestoreConstants.idColumn: subtaskRef.id});
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'user-not-signed-in', message: 'User is not signed in.');
      }
      final userId = user.uid;

      // reference individual user collection todos
      CollectionReference userTodosRef = firestore
          .collection(FirestoreConstants.userCollection)
          .doc(userId)
          .collection(FirestoreConstants.todosCollection);

      await userTodosRef.doc(todoId).delete();
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> toggleTodo(String todoId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'user-not-signed-in', message: 'User is not signed in.');
      }
      final userId = user.uid;

      // reference individual user collection todos
      CollectionReference userTodosRef = firestore
          .collection(FirestoreConstants.userCollection)
          .doc(userId)
          .collection(FirestoreConstants.todosCollection);

      await userTodosRef.doc(todoId).update({
        FirestoreConstants.isCompletedColumn: !(await userTodosRef
            .doc(todoId)
            .get()
            .then((doc) => doc[FirestoreConstants.isCompletedColumn]))
      });
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
    } catch (e) {
      print('Exception: $e');
    }
  }
}

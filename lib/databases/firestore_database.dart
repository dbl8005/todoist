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

    return firestore
        .collection(FirestoreConstants.userCollection)
        .doc(userId)
        .collection(FirestoreConstants.todosCollection)
        .snapshots()
        .asyncMap((snapshot) async {
      return Future.wait(snapshot.docs.map((doc) async {
        final subtasksSnapshot = await doc.reference
            .collection(FirestoreConstants.subtasksCollection)
            .get();
        final subtasks = subtasksSnapshot.docs
            .map((subtaskDoc) => Subtask.fromMap(subtaskDoc.data()))
            .toList();

        return TodoModel.fromMap(doc.data()).copyWith(subtasks: subtasks);
      }));
    });
  }

  Stream<List<Subtask>> getSubtasks(String todoId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
          code: 'user-not-signed-in', message: 'User is not signed in.');
    }
    final userId = user.uid;

    final todoDocRef = firestore
        .collection(FirestoreConstants.userCollection)
        .doc(userId)
        .collection(FirestoreConstants.todosCollection)
        .doc(todoId);

    return todoDocRef
        .collection(FirestoreConstants.subtasksCollection)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return <Subtask>[];
      }

      return snapshot.docs
          .map((doc) => Subtask.fromMap(doc.data() ?? <String, dynamic>{}))
          .toList();
    });
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

  Future<void> toggleSubtask(String todoId, String subtaskId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'user-not-signed-in', message: 'User is not signed in.');
      }
      final userId = user.uid;

      // Reference to the subtask document
      final subtaskRef = firestore
          .collection(FirestoreConstants.userCollection)
          .doc(userId)
          .collection(FirestoreConstants.todosCollection)
          .doc(todoId)
          .collection(FirestoreConstants.subtasksCollection)
          .doc(subtaskId);

      // Fetch current subtask data
      final subtaskDoc = await subtaskRef.get();

      if (!subtaskDoc.exists) {
        print("Subtask not found.");
        return;
      }

      final bool currentStatus =
          (subtaskDoc.data()?[FirestoreConstants.isCompletedColumn] ?? false)
              as bool;

      // Toggle the isCompleted status
      await subtaskRef.update({
        FirestoreConstants.isCompletedColumn: !currentStatus,
      });
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
    } catch (e) {
      print('Exception: $e');
    }
  }

  removeSubtask(String todoId, String subtaskId) {
    try {
      firestore
          .collection(FirestoreConstants.userCollection)
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection(FirestoreConstants.todosCollection)
          .doc(todoId)
          .collection(FirestoreConstants.subtasksCollection)
          .doc(subtaskId)
          .delete();
    } catch (e) {
      print('Exception: $e');
    }
  }
}

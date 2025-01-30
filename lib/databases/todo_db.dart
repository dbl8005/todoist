import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/utils/constants/sql_constants.dart';

class TodoDatabase {
  static Database? _db;
  static final TodoDatabase instance = TodoDatabase._init();

  TodoDatabase._init();

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, SqlConstants.databaseName),
      version: 1,
      onCreate: (db, version) {
        return db.execute(SqlConstants.createTodoTable);
      },
    );
  }

  Future<void> insertTodo(TodoModel todo) async {
    final db = await instance.db;
    await db.insert(SqlConstants.todoTable, todo.toMap());
  }

  Future<void> updateTodo(TodoModel todo) async {
    final db = await instance.db;
    await db.update(SqlConstants.todoTable, todo.toMap(),
        where: '${SqlConstants.idColumn} = ?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(String id) async {
    final db = await instance.db;
    await db.delete(SqlConstants.todoTable,
        where: '${SqlConstants.idColumn} = ?', whereArgs: [id]);
  }

  Future<List<TodoModel>> getTodos() async {
    final db = await instance.db;
    final List<Map<String, dynamic>> maps =
        await db.query(SqlConstants.todoTable);
    return maps.map((map) {
      return TodoModel(
        id: map[SqlConstants.idColumn],
        title: map[SqlConstants.titleColumn],
        description: map[SqlConstants.descriptionColumn],
        isCompleted: map[SqlConstants.isCompletedColumn] == 1,
      );
    }).toList();
  }
}

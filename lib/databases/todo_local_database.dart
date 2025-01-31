import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoist/models/todo_model.dart';
import 'package:todoist/utils/constants/sql_constants.dart';

class TodoLocalDatabase {
  static Database? _db;
  static final TodoLocalDatabase instance = TodoLocalDatabase._init();

  TodoLocalDatabase._init();

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db!;
  }

  /// Initializes and opens the database, creating the necessary tables if they do not exist.
  ///
  /// This function retrieves the database path, constructs the full path to the database file,
  /// and opens the database with the specified version. If the database does not exist, it
  /// executes the SQL command to create the table defined in `SqlConstants.createTodoTable`.
  ///
  /// Returns a `Future` that resolves to the opened `Database` instance.

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

  /// Inserts a [TodoModel] into the database.
  ///
  /// This function takes a [TodoModel] and inserts it into the database by
  /// executing an SQL `INSERT` statement. The values of the [TodoModel] are
  /// retrieved from the object's `toMap()` method and inserted into the
  /// appropriate columns of the database table.
  ///
  /// The function returns a `Future` that resolves when the insertion is complete.
  ///
  /// This function is used by the [TodoService] when adding a new Todo.
  Future<void> insertTodo(TodoModel todo) async {
    final db = await instance.db;
    await db.insert(SqlConstants.todoTable, todo.toMap());
  }

  /// Updates a [TodoModel] in the database.
  ///
  /// This function takes a [TodoModel] and updates the corresponding row in
  /// the database table. The values of the [TodoModel] are retrieved from the
  /// object's `toMap()` method and inserted into the appropriate columns of the
  /// database table.
  ///
  /// The function returns a `Future` that resolves when the update is complete.
  ///
  /// This function is used by the [TodoService] when updating a Todo.
  Future<void> updateTodo(TodoModel todo) async {
    final db = await instance.db;
    await db.update(SqlConstants.todoTable, todo.toMap(),
        where: '${SqlConstants.idColumn} = ?', whereArgs: [todo.id]);
  }

  /// Deletes a [TodoModel] from the database.
  ///
  /// This function takes an `id` as a parameter and deletes the corresponding
  /// row in the database table. The row is identified using the `id` column
  /// in the database.
  ///
  /// The function returns a `Future` that resolves when the deletion is complete.
  ///
  /// This function is used by the [TodoService] when removing a Todo.

  Future<void> deleteTodo(String id) async {
    final db = await instance.db;
    await db.delete(SqlConstants.todoTable,
        where: '${SqlConstants.idColumn} = ?', whereArgs: [id]);
  }

  /// Retrieves all [TodoModel] entries from the database.
  ///
  /// This function queries the database table to fetch all rows and maps each row
  /// into a [TodoModel] instance. The mapping process involves extracting values
  /// from each row and assigning them to the respective fields of the [TodoModel].
  ///
  /// Returns a `Future` that resolves to a list of [TodoModel] objects representing
  /// all the entries in the database.

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

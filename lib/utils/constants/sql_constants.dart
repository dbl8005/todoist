class SqlConstants {
  static const String databaseName = 'todo.db';
  static const String todoTable = 'todo';

  static const String idColumn = 'id';
  static const String titleColumn = 'title';
  static const String descriptionColumn = 'description';
  static const String isCompletedColumn = 'isCompleted';

  static const String createTodoTable = '''
    CREATE TABLE $todoTable (
      $idColumn TEXT PRIMARY KEY,
      $titleColumn TEXT NOT NULL,
      $descriptionColumn TEXT NOT NULL,
      $isCompletedColumn INTEGER NOT NULL
    )
  ''';
}

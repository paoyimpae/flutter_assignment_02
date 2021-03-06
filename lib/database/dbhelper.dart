import 'package:flutter_assignment_02/database/todo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;

class DataBaseHelper {
  final String tableName = "todo";
  static Database dbInstance;
  Future<Database> get db async {
    if (dbInstance == null) {
      dbInstance = await initDB();
    }
    return dbInstance;
  }
  initDB() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo.db");
    var db  = await openDatabase(path, version: 1, onCreate: createTableDB);
    return db;
  }

  void createTableDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName(
      `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
      `title` TEXT NOT NULL,
      `done` INTEGER NOT NULL
    )
    ''');
  }
  
  /* This is C R U D */
  Future<List<Todo>> getTodoDB() async {
    var dbConnection = await db;
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $tableName');
    List<Todo> todos = new List();
    for(int i = 0; i < list.length; i++) {
      Todo todo = new Todo();
      todo.id = list[i]['id'];
      todo.title = list[i]['title'];
      todo.done = list[i]['done'];
      todos.add(todo);
    }
    return todos;
  }

  Future<List<Todo>> getTodoDBForTodo() async {
    var dbConnection = await db;
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $tableName WHERE `done`=0');
    List<Todo> todos = new List();
    for(int i = 0; i < list.length; i++) {
      Todo todo = new Todo();
      todo.id = list[i]['id'];
      todo.title = list[i]['title'];
      todo.done = list[i]['done'];
      todos.add(todo);
    }
    // debugPrint("Todo : Now length is " + list.length.toString());
    return todos;
  }

  Future<List<Todo>> getTodoDBForDone() async {
    var dbConnection = await db;
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $tableName WHERE `done`=1');
    List<Todo> todos = new List();
    for(int i = 0; i < list.length; i++) {
      Todo todo = new Todo();
      todo.id = list[i]['id'];
      todo.title = list[i]['title'];
      todo.done = list[i]['done'];
      todos.add(todo);
    }
    // debugPrint("Done : Now length is " + list.length.toString());
    return todos;
  }
  
  void addTodoDB(Todo todo) async{
    var dbConnection = await db;
    String query = 'INSERT INTO $tableName (`title`, `done`) VALUES(\'${todo.title}\', ${todo.done})';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  void updateTodoDB(bool value, int id) async{
    int newvalue = value == true ? 1 : 0;
    var dbConnection = await db;
    String query = "UPDATE $tableName SET `done`=$newvalue WHERE `id`=$id";
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  void deleteTodoDB(Todo todo) async{
    var dbConnection = await db;
    String query = "DELETE FROM $tableName WHERE `id`=${todo.id}";
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  void deleteCompleteAll() async{
    var dbConnection = await db;
    String query = "DELETE FROM $tableName WHERE `done`=1";
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }
}
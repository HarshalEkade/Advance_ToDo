// import 'dart:io';

// import 'package:advanced_to_do/TodoModal.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// class DBHelper{
//   TodoModal? todoModal;

//  Database? _database;

//  Future<Database?> get database async{
//   if(_database !=null){
//     return _database;
//   }

//   Directory directory=await getApplicationCacheDirectory();
//   String path=join(directory.path,'mydatabase.db');

//   _database=await openDatabase(path,version: 1,onCreate: (db, version) {
//     db.execute(
//       '''
//         CREATE TABLE DatabaseTable(
//         id INTEGER PRIMARY KEY,
//         title TEXT,
//         description TEXT,
//         date TEXT,
//         )

//       '''
//     );
//   },);
//   return _database;

//  }

//  insertData() async{
//   Database? db=await database;
//   db!.insert('DatabaseTable',todoModal!.todoMap());
//  }
 
//  readData() async{
//   Database? db=await database;
//   final list= db!.query('DatabaseTable');
//   return list;
//  }
 
// }
import 'dart:io';
import 'package:advanced_to_do/TodoModal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    Directory directory = await getApplicationCacheDirectory();
    String path = join(directory.path, 'mydatabase.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE DatabaseTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            date TEXT
          )
          '''
        );
      },
    );
    return _database;
  }

  Future<void> insertData(TodoModal todoModal) async {
    final db = await database;
    await db!.insert('DatabaseTable', todoModal.todoMap());
  }

  Future<List<Map<String, dynamic>>> readData() async {
    final db = await database;
    return await db!.query('DatabaseTable');
  }

  Future<int> updateData(TodoModal totdoModal) async{
    final db=await database;
    return await db!.update(
      'DatabaseTable',
      totdoModal.todoMap(),
      where: 'id=?',
      whereArgs: [totdoModal.id]
    );
  }

  Future<int> deleteData(int id) async {
    final db = await database;
    return await db!.delete(
      'DatabaseTable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

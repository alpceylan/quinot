import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'db_quinot');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreatingDatabase,
    );
    return database;
  }

  Future<void> _onCreatingDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE notes(userId TEXT, id INTEGER PRIMARY KEY, title TEXT, note TEXT, createdDate TEXT, documentID TEXT)',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sqflite_manager/flutter_sqflite_manager.dart';
import 'package:sqflite/sqflite.dart';

// App
import '../main.dart';

// Database
import './db_connection.dart';

class DBScreen extends StatelessWidget {
  static const routeName = '/database-screen';

  final DatabaseConnection _connection = DatabaseConnection();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: _connection.setDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SqfliteManager(
            database: snapshot.data,
            enable: true,
            child: MyApp(),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

// Screens
import './screens/home_screen.dart';
import './screens/new_note_screen.dart';
import './screens/auth_screen.dart';
import './screens/root_screen.dart';
import './screens/note_detail_screen.dart';

// DB Screen
import './database/db_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == "/home_return") {
          return PageRouteBuilder(
            pageBuilder: (_, a1, a2) => HomeScreen(),
          );
        }

        return null;
      },
      title: 'Quinot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Color(0xff2D8D8D),
        cardColor: Colors.grey[100],
      ),
      debugShowCheckedModeBanner: false,
      home: RootScreen(),
      routes: {
        RootScreen.routeName: (ctx) => RootScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        NewNoteScreen.routeName: (ctx) => NewNoteScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
        NoteDetailScreen.routeName: (ctx) => NoteDetailScreen(),
        DBScreen.routeName: (ctx) => DBScreen(),
      },
    );
  }
}

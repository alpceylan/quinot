import 'package:flutter/material.dart';

// Services
import '../services/authentication_service.dart';

// Screens
import '../screens/home_screen.dart';
import '../screens/auth_screen.dart';

// Widgets
import '../widgets/waiting_widget.dart';

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class RootScreen extends StatefulWidget {
  static const routeName = '/root';

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authenticationService.getUser(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return WaitingWidget();
        }
        if (snapshot.data != null) {
          return HomeScreen();
        }
        return AuthScreen();
      },
    );
  }
}

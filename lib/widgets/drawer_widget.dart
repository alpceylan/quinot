import 'package:flutter/material.dart';

// Services
import '../services/authentication_service.dart';

// Screens
import '../screens/root_screen.dart';

class DrawerWidget extends StatefulWidget {
  final String username;
  final String email;

  DrawerWidget(
    this.username,
    this.email,
  );

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  AuthenticationService _authenticationService = AuthenticationService();

  @override 
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: Colors.white,
                child: Text(
                  widget.username.substring(0, 1),
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 45,
                  ),
                ),
                alignment: Alignment.center,
              ),
            ),
            accountName: Text(
              widget.username,
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            accountEmail: Text(
              widget.email,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: const Text('Logout'),
            onTap: () async {
              await _authenticationService.logout();
              Navigator.of(context).pushReplacementNamed(RootScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OurAppBar {
  static PreferredSizeWidget build(IconData icon, Function onPressedFunc) {
    return PreferredSize(
      child: AppBarWidget(
        IconButton(
          icon: Icon(
            icon,
          ),
          onPressed: onPressedFunc,
        ),
      ),
      preferredSize: Size.fromHeight(50),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  final IconButton actionButton;

  AppBarWidget(this.actionButton);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Quinot',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Theme.of(context).accentColor,
      ),
      actions: [actionButton],
    );
  }
}

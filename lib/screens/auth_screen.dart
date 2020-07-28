import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Services
import '../services/authentication_service.dart';

// Screens
import '../screens/root_screen.dart';

// Widgets
import '../widgets/modern_input.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthenticationService _authenticationService = AuthenticationService();

  Widget _authButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          try {
            if (isLogin) {
              await _authenticationService.login(
                _emailController.text,
                _passwordController.text,
              );
            } else {
              await _authenticationService.signup(
                _usernameController.text,
                _emailController.text,
                _passwordController.text,
              );
            }

            Navigator.of(context).pushReplacementNamed(RootScreen.routeName);
          } on PlatformException catch (error) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              ),
            );
          } catch (error) {
            print(error);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          isLogin ? 'LOGIN' : 'SIGN UP',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _authStatusChanger() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: isLogin
                  ? 'Don\'t have an Account? '
                  : 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: isLogin ? 'Sign Up' : 'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Builder(
        builder: (context) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'QUINOT',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      if (!isLogin)
                        ModernInput(
                          text: 'Username',
                          icon: Icons.person_outline,
                          hintText: 'Enter your username',
                          controller: _usernameController,
                          isObscure: false,
                        ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ModernInput(
                        text: 'Email',
                        icon: Icons.alternate_email,
                        hintText: 'Enter your email',
                        controller: _emailController,
                        isObscure: false,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ModernInput(
                        text: 'Password',
                        icon: Icons.lock_outline,
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        isObscure: true,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      _authButton(context),
                      _authStatusChanger(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

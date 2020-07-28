import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _firestore = Firestore();

  Future<FirebaseUser> getUser() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();

    return currentUser;
  }

  Future<void> login(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signup(String username, String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').add({
      'userId': result.user.uid,
      'username': username,
      'email': email,
      'createdDate': DateTime.now().toString(),
    });
  }

  Future<void> logout() async {
    return await _firebaseAuth.signOut();
  }
}

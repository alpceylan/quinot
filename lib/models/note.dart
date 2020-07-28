// Services
import 'package:firebase_auth/firebase_auth.dart';

import '../services/authentication_service.dart';

class Note {
  AuthenticationService _authenticationService = AuthenticationService();

  final String title;
  final String note;
  final String createdDate;
  final String noteId;

  Note(
    this.title,
    this.note,
    this.createdDate,
    this.noteId,
  );

  Future<Map<String, dynamic>> noteMap(String documentID) async {
    FirebaseUser user = await _authenticationService.getUser();
    Map<String, dynamic> _map = {
      'title': title,
      'note': note,
      'createdDate': createdDate,
      'documentID': documentID,
      'userId': user.uid,
    };

    return _map;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import './authentication_service.dart';

// Models
import '../models/note.dart';

class OnlineNoteService {
  Firestore _firestore = Firestore();
  AuthenticationService _authenticationService = AuthenticationService();

  Future<String> saveNote(Note note) async {
    FirebaseUser currentUser = await _authenticationService.getUser();
    DocumentReference result = await _firestore
        .collection('user_notes')
        .document(currentUser.uid)
        .collection('notes')
        .add({
      'title': note.title,
      'note': note.note,
      'createdDate': note.createdDate,
      'noteId': note.noteId,
    });
    return result.documentID;
  }

  Future<void> updateNote(Note note, String documentID) async {
    FirebaseUser currentUser = await _authenticationService.getUser();
    await _firestore
        .collection('user_notes')
        .document(currentUser.uid)
        .collection('notes')
        .document(documentID)
        .updateData({
      'title': note.title,
      'note': note.note,
      'createdDate': note.createdDate,
      'noteId': note.noteId,
    });
  }

  Future<List<DocumentSnapshot>> getNotes() async {
    FirebaseUser currentUser = await _authenticationService.getUser();

    QuerySnapshot result = await _firestore
        .collection('user_notes')
        .document(currentUser.uid)
        .collection('notes')
        .orderBy('createdDate', descending: false)
        .getDocuments();

    return result.documents;
  }

  Future<void> deleteNote(String documentID) async {
    FirebaseUser currentUser = await _authenticationService.getUser();

    await _firestore
        .collection('user_notes')
        .document(currentUser.uid)
        .collection('notes')
        .document(documentID)
        .delete();
  }
}

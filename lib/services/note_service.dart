import 'package:firebase_auth/firebase_auth.dart';

// Database
import '../database/our_db.dart';

// Services
import './online_note_service.dart';
import './authentication_service.dart';

// Models
import '../models/note.dart';

class NoteService {
  OurDatabase _ourDatabase = OurDatabase();
  OnlineNoteService _onlineNoteService = OnlineNoteService();
  AuthenticationService _authenticationService = AuthenticationService();

  Future<int> saveNote(Note note, String documentID) async {
    return await _ourDatabase.save('notes', await note.noteMap(documentID));
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    FirebaseUser user = await _authenticationService.getUser();
    return await _ourDatabase.getAll('notes', user.uid);
  }

  Future<List<Map<String, dynamic>>> getNoteById(dynamic noteId) async {
    return await _ourDatabase.getById('notes', noteId);
  }

  Future<int> updateNote(Note note, String documentID) async {
    return await _ourDatabase.update('notes', await note.noteMap(documentID));
  }

  Future<void> deleteNote(dynamic noteId) async {
    List<Map<String, dynamic>> result = await getNoteById(noteId);
    await _onlineNoteService.deleteNote(result[0]['documentID']);
    await _ourDatabase.delete('notes', noteId);
  }
}

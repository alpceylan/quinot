import 'package:flutter/material.dart';

// Services
import '../services/note_service.dart';
import '../services/online_note_service.dart';

// Models
import '../models/note.dart';

// Widgets
import '../widgets/appbar_widget.dart';

class NewNoteScreen extends StatefulWidget {
  static const routeName = '/new-note';

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  OnlineNoteService _onlineNoteService = OnlineNoteService();
  NoteService _noteService = NoteService();

  int _dbLength;

  Future<int> _getNumberOfRows() async {
    List<Map<String, dynamic>> notes = await _noteService.getNotes();
    _dbLength = notes.length;
    return _dbLength;
  }

  @override
  void initState() {
    super.initState();
    _getNumberOfRows();
  }

  @override
  Widget build(BuildContext context) {
    void _saveNote() async {
      if (_titleController.text.length > 0 && _noteController.text.length > 0) {
        Note _note = Note(
          _titleController.text,
          _noteController.text,
          DateTime.now().toString(),
          '${_dbLength + 1}',
        );

        String documentID = await _onlineNoteService.saveNote(_note);

        if (documentID.length > 0) {
          await _noteService.saveNote(
            _note,
            documentID,
          );
          Navigator.of(context).pushReplacementNamed('/home_return');
        }
      }
    }

    return Scaffold(
      appBar: OurAppBar.build(
        Icons.save,
        _saveNote,
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                    focusColor: Theme.of(context).accentColor,
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      fontSize: 35,
                      color: Theme.of(context).accentColor,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 450,
                  width: double.infinity,
                  child: TextFormField(
                    autocorrect: false,
                    controller: _noteController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                      focusColor: Theme.of(context).accentColor,
                      labelText: 'Note',
                      labelStyle: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).accentColor,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

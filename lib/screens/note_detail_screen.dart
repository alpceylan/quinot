import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Services
import '../services/note_service.dart';
import '../services/online_note_service.dart';

// Widgets
import '../widgets/appbar_widget.dart';

// Models
import '../models/note.dart';

class NoteDetailScreen extends StatefulWidget {
  static const routeName = '/note-detail';

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  bool _isLoading = false;
  bool _editMode = false;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String title = '';
  String note = '';

  @override
  Widget build(BuildContext context) {
    NoteService _noteService = NoteService();
    OnlineNoteService _onlineNoteService = OnlineNoteService();

    final Map args = ModalRoute.of(context).settings.arguments as Map;

    final String titleArg = args['title'];
    final String date = args['date'];
    final String noteArg = args['note'];
    final String id = args['id'];
    final String documentID = args['documentId'];
    final bool isOnline = args['isOnline'];

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    if (title.length == 0) {
      title = titleArg;
    }

    if (note.length == 0) {
      note = noteArg;
    }

    TextEditingController _titleController = TextEditingController(text: title);
    TextEditingController _noteController = TextEditingController(text: note);

    void _updateNote() async {
      if (_titleController.text.length <= 0) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Title shouldn\'t be empty.'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        ));
      } else if (_noteController.text.length <= 0) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Note shouldn\'t be empty.'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        ));
      } else {
        Note _note = Note(
          _titleController.text,
          _noteController.text,
          date,
          id,
        );

        await _onlineNoteService.updateNote(_note, documentID);

        await _noteService.updateNote(
          _note,
          documentID.toString(),
        );

        setState(() {
          title = _titleController.text;
          note = _noteController.text;
          _editMode = false;
        });
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: OurAppBar.build(
        Icons.share,
        null,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 90,
                    padding: EdgeInsets.only(
                      top: 25,
                      right: 25,
                      left: 25,
                      bottom: 0,
                    ),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      DateFormat.yMMMMd().format(
                                        DateTime.parse(date),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _editMode
                                        ? TextFormField(
                                            controller: _titleController,
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                            ),
                                          )
                                        : Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _editMode
                                        ? TextFormField(
                                            controller: _noteController,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                            ),
                                          )
                                        : Text(
                                            note,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        (!_editMode && isOnline)
                            ? Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: IconButton(
                                      color: Theme.of(context).accentColor,
                                      icon: Icon(
                                        Icons.delete,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await _noteService.deleteNote(id);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      color: Theme.of(context).accentColor,
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _editMode = true;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: _editMode
          ? FloatingActionButton.extended(
              onPressed: _updateNote,
              label: Text('Save'),
              icon: Icon(Icons.save),
            )
          : null,
    );
  }
}

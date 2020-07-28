import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Services
import '../services/note_service.dart';
import '../services/online_note_service.dart';
import '../services/authentication_service.dart';

// Screens
import './new_note_screen.dart';

// Widgets
import '../widgets/note_container.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/waiting_widget.dart';

// Models
import '../models/note.dart';

// Helpers
import '../helpers/internet_helper.dart';

class HomeScreen extends StatefulWidget { 
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline;
  bool _isLoading = false;

  String username;
  String email;
  String _containText = '';

  List<String> _documentIDs = [];

  TextEditingController _filterController = TextEditingController();

  NoteService _noteService = NoteService();
  OnlineNoteService _onlineNoteService = OnlineNoteService();
  AuthenticationService _authenticationService = AuthenticationService();

  InternetHelper _internetHelper = InternetHelper();

  Firestore _firestore = Firestore.instance;

  Widget _defaultContainer(Widget ch) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ch,
    );
  }

  Future<void> _getUserInfo() async {
    FirebaseUser currentUser = await _authenticationService.getUser();
    await _firestore.collection('users').getDocuments().then((users) {
      users.documents.forEach((user) {
        if (user.data['userId'] == currentUser.uid) {
          username = user.data['username'];
          email = user.data['email'];
        }
      });
    });
  }

  Future<List<Note>> _getNotes() async {
    List<Note> _noteList = [];

    _isOnline = await _internetHelper.isInternet();

    if (_isOnline) {
      List<DocumentSnapshot> notes = await _onlineNoteService.getNotes();
      notes.forEach((note) {
        if ((note.data['title'] as String).contains(_containText)) {
          _documentIDs.insert(0, note.documentID);
          _noteList.insert(
            0,
            Note(
              note.data['title'],
              note.data['note'],
              note.data['createdDate'],
              note.data['noteId'],
            ),
          );
        }
      });
      return _noteList;
    } else {
      List<Map<String, dynamic>> notes = await _noteService.getNotes();

      notes.forEach((note) {
        if ((note['title'] as String).contains(_containText)) {
          _documentIDs.insert(0, note['documentID']);
          _noteList.insert(
            0,
            Note(
              note['title'],
              note['note'],
              note['createdDate'],
              note['id'].toString(),
            ),
          );
        }
      });
      return _noteList;
    }
  }

  Widget _buildFloatAction() {
    return FloatingActionButton.extended(
      heroTag: null,
      onPressed: () {
        if (_isOnline) {
          Navigator.of(context).pushNamed(NewNoteScreen.routeName);
        } else {
          showDialog(
            context: context,
            child: AlertDialog(
              content: Text('You should be online to add new notes.'),
              actions: [
                FlatButton(
                  child: Text('I\'M ONLINE'),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await _getNotes();
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('CLOSE'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      },
      label: Text('Add new note'),
      icon: Icon(
        Icons.add,
      ),
    );
  }

  _onTapSearch() {
    return showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Search'),
              ],
            ),
            TextField(
              controller: _filterController,
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Search',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              setState(() {
                _containText = _filterController.text;
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    return FutureBuilder(
      future: _getNotes(),
      builder: (ctx, noteSnapshot) {
        if (noteSnapshot.connectionState == ConnectionState.waiting) {
          return WaitingWidget();
        }
        if (noteSnapshot.data != null) {
          if (noteSnapshot.data.length > 0) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: OurAppBar.build(
                Icons.search,
                _onTapSearch,
              ),
              drawer: DrawerWidget(
                username,
                email,
              ),
              body: _defaultContainer(
                GridView.builder(
                  itemBuilder: (ctx, i) {
                    return NoteContainer(
                      title: noteSnapshot.data[i].title,
                      date: noteSnapshot.data[i].createdDate,
                      note: noteSnapshot.data[i].note,
                      id: noteSnapshot.data[i].noteId,
                      documentID: _documentIDs[i],
                      isOnline: _isOnline,
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: noteSnapshot.data.length,
                ),
              ),
              floatingActionButton: _buildFloatAction(),
            );
          }
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: OurAppBar.build(
            Icons.search,
            (_containText.length > 0 && noteSnapshot.data.length == 0)
                ? _onTapSearch
                : null,
          ),
          drawer: DrawerWidget(
            username,
            email,
          ),
          body: _defaultContainer(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (_containText.length > 0 && noteSnapshot.data.length == 0)
                      ? 'There is no note with this name.'
                      : 'You didn\'t add any note, start adding one!',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: _buildFloatAction(),
        );
      },
    );
  }
}

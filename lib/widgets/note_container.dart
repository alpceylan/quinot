import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Screens
import '../screens/note_detail_screen.dart';

class NoteContainer extends StatelessWidget {
  final String title;
  final String date;
  final String note;
  final String id;
  final String documentID;
  final bool isOnline;

  NoteContainer({
    @required this.title,
    @required this.date,
    @required this.note,
    @required this.id,
    @required this.documentID,
    @required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(NoteDetailScreen.routeName, arguments: {
          'title': title,
          'date': date,
          'note': note,
          'id': id,
          'documentId': documentID,
          'isOnline': isOnline,
        }).then((_) {
          Navigator.pushNamed(context, "/home_return");
        });
      },
      child: Card(
        color: Theme.of(context).cardColor,
        child: Container(
          height: 160,
          width: 160,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title.substring(0, title.length > 8 ? 8 : null),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd().format(
                      DateTime.parse(date),
                    ),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      note.substring(0, note.length < 75 ? null : 75),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

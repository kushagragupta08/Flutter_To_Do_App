import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_what_to_do_app/models/note.dart';
import 'package:flutter_what_to_do_app/utills/database_helper.dart';
import 'package:flutter_what_to_do_app/app_screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  bool grid = false;
  bool centreDocked = false;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Notes'),
          backgroundColor: Colors.deepPurpleAccent,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.brightness_low),
                onPressed: () {
                  DynamicTheme.of(context).setBrightness(Brightness.dark);
                })
          ],
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text("User"),
                  accountEmail: Text("user@email"),
                  currentAccountPicture: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    width: 100.0,
                    height: 100.0,
                    child: Image.network(
                        "https://tse2.mm.bing.net/th?id=OIP.FF0BkHsdaG2T0kiEphJYtgHaHi&pid=Api&P=0&w=300&h=300"),
                  )),
              ListTile(
                leading: Icon(Icons.add_box),
                title: Text("Add a new Task"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  navigateToDetail(Note('', '', 2), 'Add Note');
                },
              ),
              Divider(
                height: 1.0,
              ),
              ListTile(
                leading: Icon(Icons.brightness_high),
                title: Text("Switch to Light Theme"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  DynamicTheme.of(context).setBrightness(Brightness.light);
                },
              ),
              Divider(
                height: 1.0,
              ),
              ListTile(
                leading: Icon(Icons.brightness_low),
                title: Text("Switch to Dark Theme"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  DynamicTheme.of(context).setBrightness(Brightness.dark);
                },
              )
            ],
          ),
        ),
        body:
//Text("Hello User"),

            getNoteListView(),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 20.0,
          //highlightElevation: 10.0,
          onPressed: () {
            debugPrint('FAB clicked');
            navigateToDetail(Note('', '', 2), 'Add Note');
          },

          tooltip: 'Add Note',

          icon: Icon(Icons.add),
          label: Text('Add a Task'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            elevation: 5.0,
            //shape: CircularNotchedRectangle(),
            notchMargin: 1.0,
            color: Colors.white,
            child: Container(
              height: 50.0,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: IconButton(
                          icon: Icon(Icons.assignment),
                          color: Colors.white,
                          iconSize: 30.0,
                          onPressed: () {
                            //  navigateToDetail(Note('', '', 2), 'Add Note');
                          }),
                    ),

                    // Expanded(child: Text("Add Note"),)

                    Container(
                      margin: EdgeInsets.only(left: 278.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        color: Colors.white,
                        iconSize: 30.0,
                        onPressed: () {
                          //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked;
                        },
                      ),
                    )
                  ]),
            )));
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    int color = Theme.of(context).textSelectionColor.red;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Column(children: <Widget>[
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.greenAccent[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            elevation: 10.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(
                this.noteList[position].title,
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(
                this.noteList[position].date,
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      child: CupertinoAlertDialog(
                        title: Text("Do You really Want to delete ?",
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                            )),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                            onPressed: () {
                              _delete(context, noteList[position]);
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
                },
              ),
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToDetail(this.noteList[position], 'Edit Note');
              },
            ),
          ),
        ]);
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.deepOrangeAccent;
        break;
      case 2:
        return Colors.blueGrey;
        break;

      default:
        return Colors.blueGrey;
    }
  }

  getFloatButtonPosition() {}

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.keyboard_arrow_right);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}

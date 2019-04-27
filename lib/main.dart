import 'package:flutter/material.dart';
import 'package:flutter_what_to_do_app/app_screens/note_list.dart';
import 'package:flutter_what_to_do_app/app_screens/note_detail.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) =>
        new ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'NoteKeeper',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: NoteList(),
          );
        }
    );
  }
}

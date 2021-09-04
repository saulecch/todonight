import 'package:flutter/material.dart';
import 'package:todonight/screens/notes_home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App notas',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
      ),
      home: NotesPage(),
    );
  }
}

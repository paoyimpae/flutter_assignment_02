import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/ui_pages/create.dart';
import 'package:flutter_assignment_02/ui_pages/todolist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TodoList(),
        '/create': (context) => CreateList(),
      },
    );
  }
}
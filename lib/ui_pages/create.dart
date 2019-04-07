import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/database/dbhelper.dart';
import 'package:flutter_assignment_02/database/todo.dart';
import 'package:flutter_assignment_02/ui_pages/todolist.dart';


class CreateList extends StatefulWidget {
  @override
  CreateListState createState() {
    return CreateListState();
  }
}

class CreateListState extends State<CreateList> {
  final _formkey = GlobalKey<FormState>();
  String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject")
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Subject",
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                title = value;
                if (value.isEmpty) {
                  return 'Please fill subject';
                }
              },
              onSaved: (value) {
                title = value;
              },
            ),
            
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Expanded(
                  child: ButtonTheme( 
                      child: RaisedButton(
                        child: Text('Save'),
                        textColor: Colors.white,
                        onPressed: submitTodo,
                      )
                    ),
                )   
              ],
            )
          ],
        ),
      ),
    );
  }
  void submitTodo() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TodoList()));
    } else {
      return null;
    }
    Todo todo = Todo();
    todo.title = title;
    todo.done = 0;
    DataBaseHelper databaseHelper = DataBaseHelper();
    databaseHelper.addTodoDB(todo);
  }
}
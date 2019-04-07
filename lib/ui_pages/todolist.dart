import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/database/dbhelper.dart';
import 'package:flutter_assignment_02/database/todo.dart';
import 'package:flutter_assignment_02/ui_pages/create.dart';

Future<List<Todo>> getTodoDBForAll() async {
    DataBaseHelper databaseHelper = DataBaseHelper();
    Future<List<Todo>> todos = databaseHelper.getTodoDB();
    return todos;
}

Future<List<Todo>> getTodoDBForTodo() async {
    DataBaseHelper databaseHelper = DataBaseHelper();
    Future<List<Todo>> todos = databaseHelper.getTodoDBForTodo();
    return todos;
}

Future<List<Todo>> getTodoDBForDone() async {
    DataBaseHelper databaseHelper = DataBaseHelper();
    Future<List<Todo>> todos = databaseHelper.getTodoDBForDone();
    return todos;
}

void setTodo(bool value, int i) async {
    DataBaseHelper databaseHelper = DataBaseHelper();
    databaseHelper.updateTodoDB(value, i);
    // debugPrint(value.toString() + ':' + i.toString());
}

class TodoList extends StatefulWidget {
  TodoList();
  
  @override
  TodoListState createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  void initState() {
    super.initState();
  }
      
  int page = 0;
  @override
  Widget build(BuildContext context) {
  List buttonList = 
  <Widget>[
    IconButton(
      icon: Icon(Icons.add),
      onPressed: () { 
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateList()));
      },
    ),
    IconButton(
      icon: Icon(Icons.delete),
      onPressed: () { 
        DataBaseHelper databaseHelper = DataBaseHelper();
        databaseHelper.deleteCompleteAll();
        page = 1;
        setState(() {
          context = context; 
        });
      },
    ),
  ];
  List pageList = 
  <Widget>[
    FutureBuilder<List<Todo>>(
      future: getTodoDBForTodo(),
      builder: (context, snapshot) {
        if(snapshot.data != null) {
          if(snapshot.data.length != 0) {
            return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
                // debugPrint("Todo : Now length is " + snapshot.data.length.toString());
                return CheckboxListTile(
                  title: Text(snapshot.data[index].title),
                  value: snapshot.data[index].done == 1 ? true : false,
                  onChanged: (bool value) {
                    setState(() {
                      setTodo(value, snapshot.data[index].id);
                      TodoList();
                    });
                  },
                );
          }); 
          } else {
            return Text('No data found..');
          }
        } else {
          return Text('No data found..');
        }
      },
    )
    , FutureBuilder<List<Todo>>(
      future: getTodoDBForDone(),
      builder: (context, snapshot) {
        if(snapshot.data != null) {
          if(snapshot.data.length != 0) {
            return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
                // debugPrint("Todo : Now length is " + snapshot.data.length.toString());
                return CheckboxListTile(
                  title: Text(snapshot.data[index].title),
                  value: snapshot.data[index].done == 1 ? true : false,
                  onChanged: (bool value) {
                    setState(() {
                      setTodo(value, snapshot.data[index].id);
                      TodoList();
                    });
                  },
                );
          }); 
          } else {
            return Text('No data found..');
          }
        } else {
          return Text('No data found..');
        }
      },
    )
  ];


  return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Todo"),
            actions: <Widget>[buttonList[page]],
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: pageList[page] 
          ),
          
          bottomNavigationBar: SizedBox(
            height: 58,
            child: TabBar(
              tabs: <Widget>[
              Tab(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.list),
                    Text('Task'),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.done_all),
                    Text('Completed'),
                  ],
                ),  
              ),
              ],   
              labelColor: Colors.pink,
              indicatorColor: Colors.pink,
              onTap: (value) {
                setState(() {
                  page = value;
                });
                // debugPrint('${page}');
              },
            ),   
          ),
        ),
      ),
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}

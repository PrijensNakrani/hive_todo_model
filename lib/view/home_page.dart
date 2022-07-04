import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_todo_model/main.dart';
import 'package:hive_todo_model/model/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<TodoModel>? todoBox;
  final _title = TextEditingController();
  final _detail = TextEditingController();

  @override
  void initState() {
    todoBox = Hive.box<TodoModel>(todoBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder(
        valueListenable: todoBox!.listenable(),
        builder: (BuildContext context, Box<TodoModel> todos, _) {
          List<int> keys = todos.keys.cast<int>().toList();
          return ListView.builder(
            itemCount: todoBox!.length,
            itemBuilder: (context, index) {
              final int key = keys[index];
              final todo = todos.get(key);
              return ListTile(
                title: Text(todo!.title.toString()),
                subtitle: Text(todo.detail.toString()),
                leading: Text(
                  "$key",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  Text("Add Tode"),
                                  TextFormField(
                                    controller: _title,
                                    decoration:
                                        InputDecoration(hintText: "Title"),
                                  ),
                                  TextFormField(
                                    controller: _detail,
                                    decoration:
                                        InputDecoration(hintText: "Detail"),
                                  ),
                                ],
                              ),
                              actions: [
                                MaterialButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cencel"),
                                ),
                                MaterialButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    final title = _title.text;
                                    final detail = _detail.text;
                                    TodoModel todo = TodoModel(
                                        title: title,
                                        detail: detail,
                                        isCompleted: false);
                                    todoBox?.put(key, todo);
                                    Navigator.pop(context);
                                    _title.clear();
                                    _detail.clear();
                                  },
                                  child: Text("Update"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.update,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                children: const [
                                  Text("Do you want to delete?"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("NO"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await todoBox!.delete(key);
                                    Navigator.pop(context);
                                  },
                                  child: Text("YES"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text("Add Tode"),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                    TextFormField(
                      controller: _detail,
                      decoration: InputDecoration(hintText: "Detail"),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cencel"),
                  ),
                  MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      final title = _title.text;
                      final detail = _detail.text;
                      TodoModel todo = TodoModel(
                          title: title, detail: detail, isCompleted: false);
                      todoBox?.add(todo);
                      Navigator.pop(context);
                      _title.clear();
                      _detail.clear();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

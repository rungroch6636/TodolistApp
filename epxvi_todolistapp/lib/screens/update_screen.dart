// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class UpdateScreen extends StatefulWidget {
  final id, title, detail;
  const UpdateScreen(this.id, this.title, this.detail);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  var _id, _title, _detail;
  final _todo_title = TextEditingController();
  final _todo_detail = TextEditingController();

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _title = widget.title;
    _detail = widget.detail;
    _todo_title.text = widget.title;
    _todo_detail.text = widget.detail;
  }

  Future<void> _showDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          actions: [
            TextButton.icon(
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Colors.red[900],
              ),
              label: const Text(
                'Delete',
                style: TextStyle(color: Color.fromARGB(255, 183, 28, 28)),
              ),
              onPressed: () {
                deleteTodo();
                Navigator.maybeOf(context);
                {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            ),
            TextButton.icon(
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.amber[900],
              ),
              label: const Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 255, 111, 0)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future updateTodo() async {
    var url = Uri.http(
        '192.168.1.119:8000', '/api/update-todolist/${_id}'); //ใช้ ip เครื่อง
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata =
        '{"title":"${_todo_title.text}","detail":"${_todo_detail.text}"}';
    var response = await http.put(url, headers: header, body: jsondata);

    print('----result----');
    print(response.body);
  }

  Future deleteTodo() async {
    var url = Uri.http(
        '192.168.1.119:8000', '/api/delete-todolist/${_id}'); //ใช้ ip เครื่อง
    Map<String, String> header = {"Content-type": "application/json"};
    var response = await http.delete(url, headers: header);

    print('----result----');
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit And Delete'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red[100],
              ),
              onPressed: () {
                //todo Delete dialog yes no
                print('Delete >> $_id');
                _showDialogDelete();
                // Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          controller: _todo_title,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            label: Text('${_todo_title.text}'),
            hintText: 'ชื่อเรื่อง',
          ),
        ),
        SizedBox(
          height: 24,
        ),
        TextField(
          minLines: 4,
          maxLines: 8,
          controller: _todo_detail,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            label: Text('${_todo_detail.text}'),
            hintText: 'รายละเอียด',
          ),
        ),
        SizedBox(
          height: 24,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellow[800]),
            //padding: MaterialStateProperty.all(EdgeInsets.all(8)),
            //textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Confirm Edit',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          onPressed: () {
            print('---------');
            print('title >> ${_todo_title.text}');
            print('detail >> ${_todo_detail.text}');
            updateTodo();
            setState(() {
              print('Update Success');
            });
          },
        ),
      ]),
    );
  }
}

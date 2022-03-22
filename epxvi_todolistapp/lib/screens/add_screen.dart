// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _todo_title = TextEditingController();
  final _todo_detail = TextEditingController();

  Future postTodo() async {
    // var url = Uri.https('3ac3-2405-9800-b820-b129-ec3d-8792-e24d-39e4.ngrok.io',
    //     '/api/post-todolist');
    
    var url = Uri.http('192.168.1.119:8000', '/api/post-todolist'); //ใช้ ip เครื่อง

    Map<String, String> header = {"Content-type": "application/json"};

    String jsondata =
        '{"title":"${_todo_title.text}","detail":"${_todo_detail.text}"}';
    var response = await http.post(url, headers: header, body: jsondata);

    print('----result----');
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          controller: _todo_title,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            label: Text('Title'),
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
            label: Text('Detail'),
            hintText: 'รายละเอียด',
          ),
        ),
        SizedBox(
          height: 24,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
            //padding: MaterialStateProperty.all(EdgeInsets.all(8)),
            //textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'เพิ่มรายการ',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          onPressed: () {
            print('---------');
            print('title >> ${_todo_title.text}');
            print('detail >> ${_todo_detail.text}');

            postTodo();

            setState(() {
              _todo_title.clear();
              _todo_detail.clear();
            });
          },
        ),
      ]),
    );
  }
}

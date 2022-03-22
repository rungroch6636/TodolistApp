// ignore_for_file: prefer_const_constructors, must_call_super, non_constant_identifier_names, avoid_print
import 'package:flutter/material.dart';
import 'package:epxvi_todolistapp/screens/add_screen.dart';
import 'package:epxvi_todolistapp/screens/update_screen.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _todolistitem = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    loadTodolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('TodoList..')),
      // ignore: prefer_const_literals_to_create_immutables
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: RichText(text: TextSpan(children: [
                TextSpan(text: 'TodoList..  ' ),
                TextSpan(text: 'Tips', style: TextStyle(color: Colors.yellowAccent) ),
              ]),),

              background: Image.asset(
                'images/minnie.png',
                height: 250,
              ),
              
            ),
          ),
          TodolistShow(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => AddScreen())),
          ).then((value) {
            setState(() {
              print('SetState AddItem');
              loadTodolist();
            });
          });
        },
      ),
    );
  }

  Widget TodolistShow() {
    return SliverFixedExtentList(
      itemExtent: 70.0,
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Card(
            child: ListTile(
              title: Text('title :: ${_todolistitem[index]['title']}'),
              subtitle: Text('subtitle :: ${_todolistitem[index]['detail']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateScreen(
                            _todolistitem[index]['id'],
                            _todolistitem[index]['title'],
                            _todolistitem[index]['detail'],
                          )),
                ).then((value) {
                  setState(() {
                    print('SetState Edit and Delete');
                    loadTodolist();
                  });
                });
              },
            ),
          );
        },
        childCount: _todolistitem.length,
      ),
    );
  }

  Future<void> loadTodolist() async {
    var url = Uri.http('192.168.1.119:8000', '/api/all-todolist');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes); //jsonDecode(response.body);
    print(result);

    setState(() {
      _todolistitem = jsonDecode(result);
    });
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}

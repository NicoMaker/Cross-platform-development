import 'package:flutter/material.dart';
import 'todolist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do LIST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      // Il widget TodoListScreen da todolist.dart è ora la home page.
      home: const TodoListScreen(),
    );
  }
}

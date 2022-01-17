import 'package:flutter/material.dart';
import 'package:flutter_todos/home_bottom_navigation_bar/views/edit_todo_page.dart';
import 'package:flutter_todos/todos/views/add_todo_page.dart';

import 'home_bottom_navigation_bar/views/home_bottom_navigation_bar.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timer',
      routes: {
        EditTodoPage.routeName: (context) => const EditTodoPage(),
        AddTodoView.routeName: (context) => const AddTodoView(),
      },
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(109, 234, 255, 1),
        colorScheme: const ColorScheme.light(
          secondary: Color.fromRGBO(72, 74, 126, 1),
        ),
      ),
      home: const HomePageBottomNavigationBar(),
    );
  }
}
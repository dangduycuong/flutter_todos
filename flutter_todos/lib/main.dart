import 'package:flutter/material.dart';
import 'package:flutter_todos/app.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initialize hive
  await Hive.initFlutter();
  // Registering the adapter
  Hive.registerAdapter(TodoAdapter());
  // Opening the box. tạo một box
  await Hive.openBox('todosBox');
  runApp(const App());
}

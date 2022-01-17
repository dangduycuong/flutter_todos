import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/todos/bloc/todos_bloc.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosBloc(),
      child: const AddTodoView(),
    );
  }
}

class AddTodoView extends StatefulWidget {
  const AddTodoView({Key? key}) : super(key: key);

  static const routeName = 'AddTodoPage';

  @override
  _AddTodoViewState createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personFormKey = GlobalKey<FormState>();
  late final Box box;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  _addTodo() async {
    Todo todo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: false,
    );
    // box.add(todo);
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('todosBox');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(builder: (context, state) {
      return const Text('ss');
    }, listener: (context, state) {

    });
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                validator: _fieldValidator,
                decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    labelText: 'Title',
                    hintText: 'title todo'),
              ),
              TextFormField(
                controller: _descriptionController,
                validator: _fieldValidator,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  labelText: 'Description',
                  hintText: 'Description',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Wrap(
                spacing: 16,
                alignment: WrapAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addTodo();
                      Navigator.of(context).pop();
                      if (_personFormKey.currentState!.validate()) {
                        _addTodo();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

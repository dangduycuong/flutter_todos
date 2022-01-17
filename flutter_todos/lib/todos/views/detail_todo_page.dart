import 'package:flutter/material.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';
import 'package:hive/hive.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage({
    Key? key,
    required this.index,
    required this.person,
  }) : super(key: key);

  final int index;
  final Todo person;

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UpdateTodoForm(
          index: widget.index,
          todo: widget.person,
        ),
      ),
    );
  }
}

class UpdateTodoForm extends StatefulWidget {
  final int index;
  final Todo todo;

  const UpdateTodoForm({Key? key,
    required this.index,
    required this.todo,
  }) : super(key: key);

  @override
  _UpdateTodoFormState createState() => _UpdateTodoFormState();
}

class _UpdateTodoFormState extends State<UpdateTodoForm> {
  final _personFormKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late final Box box;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  // Update info of people box
  _updateTodo() {
    Todo newTodo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: false,
    );

    box.putAt(widget.index, newTodo);
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('todosBox');
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _personFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Title'),
          TextFormField(
            controller: _titleController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Description'),
          TextFormField(
            controller: _descriptionController,
            validator: _fieldValidator,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
            child: Container(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_personFormKey.currentState!.validate()) {
                    _updateTodo();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Update'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

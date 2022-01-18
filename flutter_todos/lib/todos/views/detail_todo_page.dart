import 'package:flutter/material.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';
import 'package:hive/hive.dart';

class TodoDetailPage extends StatefulWidget {
  static const routeName = 'TodoDetailPage';

  const TodoDetailPage({
    Key? key,
    required this.index,
    required this.todo,
  }) : super(key: key);

  final int index;
  final Todo todo;

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
          todo: widget.todo,
        ),
      ),
    );
  }
}

class UpdateTodoForm extends StatefulWidget {
  final int index;
  final Todo todo;

  const UpdateTodoForm({
    Key? key,
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
    _descriptionController =
        TextEditingController(text: widget.todo.description);
  }

  Widget _cancelElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Cancel'),
    );
  }

  Widget _saveElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        if (_personFormKey.currentState!.validate()) {
          _updateTodo();
          Navigator.of(context).pop();
        }
      },
      child: const Text('Save'),
    );
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
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return TextFormField(
                    controller: _descriptionController,
                    validator: _fieldValidator,
                    maxLines: null,
                  );
                }
                return Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text('Completed'),
                  ],
                );
              },
              itemCount: 2,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _cancelElevatedButton(),
              _saveElevatedButton(),
            ],
          ),
        ],
      ),
    );
  }
}

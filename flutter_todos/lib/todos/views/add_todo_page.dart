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
      create: (_) => TodosBloc(),
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

  // final _personFormKey = GlobalKey<FormState>();
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
    context.read<TodosBloc>().add(TodoAddEvent(todo));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Get reference to an already opened box
  //   box = Hive.box('todosBox');
  // }

  Widget _titleTextFormField() {
    return TextFormField(
      controller: _titleController,
      validator: _fieldValidator,
      decoration: const InputDecoration(
          icon: Icon(Icons.title), labelText: 'Title', hintText: 'title todo'),
    );
  }

  Widget _descriptionTextFormField() {
    return TextFormField(
      controller: _descriptionController,
      validator: _fieldValidator,
      maxLines: null,
      decoration: const InputDecoration(
        icon: Icon(Icons.description),
        labelText: 'Description',
        hintText: 'Description',
      ),
    );
  }

  Widget _heightSpacing(double valueHeight) {
    return SizedBox(
      height: valueHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodosBloc, TodosState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Todo'),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _titleTextFormField(),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        _descriptionTextFormField(),
                    itemCount: 1,
                  ),
                ),
                _heightSpacing(16),
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

                        // if (_personFormKey.currentState!.validate()) {
                        //   _addTodo();
                        //   Navigator.of(context).pop();
                        // }
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
    }, listener: (context, state) {
      if (state is TodosAddState) {
        Navigator.of(context).pop();
      }
    });
  }
}

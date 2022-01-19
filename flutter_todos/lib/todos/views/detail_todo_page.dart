import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/todos/bloc/todos_bloc.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';

class TodoInfoPage extends StatelessWidget {
  const TodoInfoPage({Key? key}) : super(key: key);

  static const routeName = 'TodoInfoPage';

  @override
  Widget build(BuildContext context) {
    final int index = ModalRoute.of(context)!.settings.arguments as int;
    return BlocProvider(
      //_getTodoDetail(TodosDetailEvent
      create: (_) => TodosBloc()..add(TodosDetailEvent(index)),
      child: const TodoInfoView(),
    );
  }
}

class TodoInfoView extends StatefulWidget {
  const TodoInfoView({Key? key}) : super(key: key);

  @override
  _TodoInfoViewState createState() => _TodoInfoViewState();
}

class _TodoInfoViewState extends State<TodoInfoView> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  int index = 0;
  bool isCompleted = false;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  Widget _createElevatedButton(String title) {
    return ElevatedButton(
      onPressed: () {
        if (title == 'Cancel') {
          Navigator.of(context).pop();
        } else {
          _modifyTodo();
        }
      },
      child: Text(title),
    );
  }

  _modifyTodo() {
    Todo newTodo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: isCompleted,
    );
    context.read<TodosBloc>().add(TodosModifyEvent(index, newTodo));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodosBloc, TodosState>(builder: (context, state) {
      if (state is TodosDetailState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Todo'),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
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
                          Checkbox(
                              value: isCompleted,
                              onChanged: (value) {
                                isCompleted = value!;
                                setState(() {});
                              }),
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
                    _createElevatedButton('Cancel'),
                    _createElevatedButton('Save'),
                  ],
                ),
              ],
            ),
          ),
        );
      }
      return const Center(
        child: Text('cdd Loading...'),
      );
    }, listener: (context, state) {
      if (state is TodosDetailState) {
        index = state.index;
        _titleController = TextEditingController(text: state.todo.title);
        _descriptionController =
            TextEditingController(text: state.todo.description);
        isCompleted = state.todo.isCompleted;
      }
      if (state is TodosModifyState) {
        print('cdd add xong data');
        Navigator.pop(context);
      }
    });
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/todos/bloc/todos_bloc.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';
import 'package:flutter_todos/todos/views/detail_todo_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  static const routeName = 'TodosPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodosBloc()..add(TodosLoadDataEvent()),
      child: BlocConsumer<TodosBloc, TodosState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case TodosLoadingDataState:
              return Expanded(
                child: (Platform.isIOS)
                    ? const Center(child: CupertinoActivityIndicator())
                    : const Center(child: CircularProgressIndicator()),
              );
            case TodosLoadDataSuccessState:
              return const TodosView();
            case TodosModifyState:
              return const TodosView();
            default:
              return const Center(
                child: Text('Empty'),
              );
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}

class TodosView extends StatefulWidget {
  const TodosView({Key? key}) : super(key: key);

  @override
  _TodosViewState createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  _deleteInfo(int index) {
    context.read<TodosBloc>().add(TodosDeleteEvent(index));
  }

  Widget _buildListView(Box box) {
    return ListView.builder(
      itemCount: box.length,
      itemBuilder: (context, index) {
        Todo todo = box.getAt(index);

        return InkWell(
          onTap: () => _navigateAndDisplayReloadUpdate(context, index),
          child: _buildCellForRow(todo, index),
        );
      },
    );
  }

  void _navigateAndDisplayReloadUpdate(BuildContext context, int index) async {
    await Navigator.pushNamed(context, TodoInfoPage.routeName,
        arguments: index);
    print('cdd after _navigateAndDisplayReloadUpdate');
    context.read<TodosBloc>().add(TodoReloadDataEvent());
    setState(() {

    });

    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(const SnackBar(content: Text('Update todo success')));
  }

  Widget _buildCellForRow(Todo todo, int index) {
    return ListTile(
      leading: Checkbox(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        value: todo.isCompleted,
        onChanged: (value) {
          print('cdd checkbox clicked $value');
          Todo newTodo = Todo(
            title: todo.title,
            description: todo.description,
            isCompleted: value!,
          );
          setState(() {

          });
          context.read<TodosBloc>().add(TodosModifyEvent(index, newTodo));
        },
      ),
      title: Text(
        todo.title,
      ),
      subtitle: Text(
        todo.description,
        maxLines: 1,
      ),
      trailing: IconButton(
        onPressed: () {
          _deleteInfo(index);
          setState(() {

          });
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: _buildListView(context.read<TodosBloc>().box),
    );
  }
}

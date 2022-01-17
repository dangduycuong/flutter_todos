import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/todos/bloc/todos_bloc.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';
import 'package:flutter_todos/todos/views/add_todo_page.dart';
import 'package:flutter_todos/todos/views/detail_todo_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosBloc()..add(TodosLoadDataEvent()),
      child: BlocConsumer<TodosBloc, TodosState>(
        builder: (context, state) {
          return const TodosView();
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
  late final Box contactBox;

  // Delete info from people box
  _deleteInfo(int index) {
    contactBox.deleteAt(index);

    print('Item deleted from box at index: $index');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    contactBox = Hive.box('todosBox');
  }

  Widget _buildListView(Box box) {
    return ListView.builder(
      itemCount: box.length,
      itemBuilder: (context, index) {
        var currentBox = box;
        Todo todoData = currentBox.getAt(index);
        // var todoData = currentBox.getAt(index)!;

        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodoDetailPage(
                index: index,
                person: todoData,
              ),
            ),
          ),
          child: _buildCellForRow(todoData, index),
        );
      },
    );
  }

  Widget _buildCellForRow(Todo todoData, int index) {
    return ListTile(
      leading: Checkbox(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        value: todoData.isCompleted,
        onChanged: (value) {},
      ),
      title: Text(
        todoData.title,
      ),
      subtitle: Text(todoData.description),
      trailing: IconButton(
        onPressed: () => _deleteInfo(index),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddTodoView(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: contactBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Empty'),
            );
          } else {
            return _buildListView(box);
          }
        },
      ),
    );
  }
}

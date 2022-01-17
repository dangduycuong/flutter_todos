import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'todos_event.dart';

part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  late final Box box;
  List<Todo> todos = [];

  TodosBloc() : super(TodosLoadDataState()) {
    print('cdd run super TodosLoadDataState');
    on<TodosLoadDataEvent>((event, emit) {
      print('cdd run here when');
      // TODO: implement event handler
    });
    on<TodoAddEvent>(_addTodo);
    on<TodoChangeStatusEvent>(_changeStatus);
  }

  void _addTodo(TodoAddEvent event, Emitter<TodosState> emit) {
    Todo todo = event.todo;
    box.add(todo);
    emit(TodosAddState(todo: todo));
  }

  void _changeStatus(TodoChangeStatusEvent event, Emitter<TodosState> emit) {
    // todos[event.index].isCompleted = !(todos[event.index].isCompleted!);
    emit(TodosChangeStatusState());
  }
}

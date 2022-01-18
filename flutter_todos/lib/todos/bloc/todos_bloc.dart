import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_todos/todos/models/todo_model.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'todos_event.dart';

part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  late final Box box;

  TodosBloc() : super(TodosLoadingDataState()) {
    on<TodosLoadDataEvent>(_loadingTodos);
    on<TodoAddEvent>(_addTodo);
    on<TodosModifyEvent>(_modifyTodo);
    on<TodosDeleteEvent>(_deleteTodo);
  }

  void _loadingTodos(TodosLoadDataEvent event, Emitter<TodosState> emit) async {
    await Future.delayed(const Duration(seconds: 2), () {});

    box = Hive.box('todosBox');

    emit(TodosLoadDataSuccessState());
  }

  void _addTodo(TodoAddEvent event, Emitter<TodosState> emit) {
    Todo todo = event.todo;
    box.add(todo);
    emit(TodosAddState(todo: todo));
  }

  void _modifyTodo(TodosModifyEvent event, Emitter<TodosState> emit) {
    Todo newTodo = event.todo;
    int index = event.index;

    box.putAt(index, newTodo);

    emit(TodosModifyState());
  }

  void _deleteTodo(TodosDeleteEvent event, Emitter<TodosState> emit) {
    emit(TodosLoadingDataState());
    box.deleteAt(event.index);
    emit(TodosLoadDataSuccessState());
  }
}

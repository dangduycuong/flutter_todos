import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    on<TodosDetailEvent>(_getTodoDetail);
    on<TodoReloadDataEvent>(_reloadData);
  }

  void _loadingTodos(TodosLoadDataEvent event, Emitter<TodosState> emit) async {
    await Future.delayed(const Duration(seconds: 1), () {});

    box = Hive.box('todosBox');

    emit(TodosLoadDataSuccessState());
  }

  void _addTodo(TodoAddEvent event, Emitter<TodosState> emit) async {
    Todo todo = event.todo;
    try {
      box = Hive.box('todosBox');
      await box.add(todo);
    } catch (_) {}

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
    try {
      box.deleteAt(event.index);
    } catch (error) {
      emit(TodoErrorState(error.toString()));
    }

    emit(TodosLoadDataSuccessState());
  }

  void _getTodoDetail(TodosDetailEvent event, Emitter<TodosState> emit) {
    box = Hive.box('todosBox');
    Todo todo = box.getAt(event.index);
    emit(TodosDetailState(todo, event.index));
  }

  void _reloadData(TodoReloadDataEvent event, Emitter<TodosState> emit) {
    print('cdd _reloadData');
    emit(TodosLoadDataSuccessState());
  }
}

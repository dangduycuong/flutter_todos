part of 'todos_bloc.dart';

@immutable
abstract class TodosEvent {}

class TodosLoadDataEvent extends TodosEvent {}

class TodoAddEvent extends TodosEvent {
  final Todo todo;

  TodoAddEvent(this.todo);

  List<Object> get props => [todo];
}

class TodosModifyEvent extends TodosEvent {
  final int index;

  final Todo todo;

  TodosModifyEvent(this.index, this.todo);

  List<Object> get props => [index, todo];
}

class TodosDeleteEvent extends TodosEvent {
  final int index;

  TodosDeleteEvent(this.index);

  List<Object> get props => [index];
}

class TodosDetailEvent extends TodosEvent {
  final int index;

  TodosDetailEvent(this.index);

  List<Object> get props => [index];
}

class TodoReloadDataEvent extends TodosEvent {}

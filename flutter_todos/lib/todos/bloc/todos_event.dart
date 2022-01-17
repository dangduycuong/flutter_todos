part of 'todos_bloc.dart';

@immutable
abstract class TodosEvent {}

class TodosLoadDataEvent extends TodosEvent {}

class TodoAddEvent extends TodosEvent {
  final Todo todo;

  TodoAddEvent(this.todo);

  List<Object> get props => [todo];
}

class TodoChangeStatusEvent extends TodosEvent {
  final int index;

  TodoChangeStatusEvent(this.index);

  List<Object> get props => [index];
}

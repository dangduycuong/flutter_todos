part of 'todos_bloc.dart';

@immutable
abstract class TodosState {}

class TodosLoadDataState extends TodosState {}

class TodosLoadDataSstate extends TodosState {}

class TodosAddState extends TodosState {
  final Todo? todo;

  TodosAddState({this.todo});
}

class TodosChangeStatusState extends TodosState {}

part of 'todos_bloc.dart';

@immutable
abstract class TodosState {}

class TodosLoadingDataState extends TodosState {}

class TodosLoadDataSuccessState extends TodosState {}

class TodosAddState extends TodosState {
  final Todo? todo;

  TodosAddState({this.todo});
}

class TodosModifyState extends TodosState {}

class TodosDeleteState extends TodosState {}



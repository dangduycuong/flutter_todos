part of 'todos_bloc.dart';

@immutable
abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosLoadingDataState extends TodosState {}

class TodosLoadDataSuccessState extends TodosState {
}

class TodosAddState extends TodosState {
  final Todo? todo;

  const TodosAddState({this.todo});
}

class TodosModifyState extends TodosState {}

class TodosDeleteState extends TodosState {}

class TodosDetailState extends TodosState {
  final Todo todo;
  final int index;

  const TodosDetailState(this.todo, this.index);
}

class TodoErrorState extends TodosState {
  const TodoErrorState(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

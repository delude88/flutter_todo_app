part of 'todos_cubit.dart';

abstract class TodosState extends Equatable {
  const TodosState();
}

class TodosInitial extends TodosState {
  @override
  List<Object> get props => [];
}

class TodosLoading extends TodosState {
  @override
  List<Object?> get props => [];
}

class TodosError extends TodosState {
  final String message;

  const TodosError(this.message);

  @override
  List<Object?> get props => [message];
}

class TodosLoaded extends TodosState {
  final Iterable<Todo> todos;

  const TodosLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

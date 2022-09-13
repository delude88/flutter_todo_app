part of 'todo_cubit.dart';

abstract class TodoState extends Equatable {
  const TodoState();
}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {
  final String id;

  const TodoLoading(this.id);

  @override
  List<Object> get props => [id];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}

class TodoLoaded extends TodoState {
  final Todo todo;

  const TodoLoaded(this.todo);

  @override
  List<Object> get props => [];
}

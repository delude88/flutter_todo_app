import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/data/todo_repository.dart';
import 'package:flutter_todo_app/models/todo.dart';

part 'todos_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final TodoRepository _repository;

  TodosCubit(this._repository) : super(TodosInitial()) {
    emit(TodosLoading());
    _repository.connection.listen((connected) {
      if (!connected) {
        emit(TodosLoading());
      }
    });
    _repository.todos.listen((todos) {
      emit(TodosLoaded(todos));
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/data/todo_repository.dart';
import 'package:flutter_todo_app/models/todo.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _repository;
  String? _id;

  TodoCubit(this._repository) : super(TodoInitial()) {
    _repository.connection.listen((connected) {
      if (!connected) {
        final id = _id;
        if (id != null) {
          emit(TodoLoading(id));
        } else {
          emit(TodoInitial());
        }
      }
    });
    _repository.todos.listen((todos) {
      if (_id != null) {
        final todo = todos.firstWhere((item) => item.id == _id);
        emit(TodoLoaded(todo));
      }
    });
  }

  void load(String id) {
    if (_id != id) {
      _id = id;
      emit(TodoLoading(id));
      if (_repository.connected) {
        try {
          emit(TodoLoaded(_repository.getTodoById(id)));
        } catch (_) {
          emit(const TodoError("Could not find todo"));
        }
      }
    }
  }
}

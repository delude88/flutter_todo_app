import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/data/user_repository.dart';
import 'package:flutter_todo_app/models/user.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository _repository;

  UsersCubit(this._repository) : super(UsersInitial()) {
    emit(UsersLoading());
    _repository.connection.listen((connected) {
      if (!connected) {
        emit(UsersLoading());
      }
    });
    _repository.users.listen((users) {
      emit(UsersLoaded(users));
    });
  }
}

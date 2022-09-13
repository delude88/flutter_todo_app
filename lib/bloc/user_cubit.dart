import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/data/user_repository.dart';
import 'package:flutter_todo_app/models/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;
  String? _id;

  UserCubit(this._repository) : super(UserInitial()) {
    _repository.connection.listen((connected) {
      if (!connected) {
        final id = _id;
        if (id != null) {
          emit(UserLoading(id));
        } else {
          emit(UserInitial());
        }
      }
    });
    _repository.users.listen((users) {
      if (_id != null) {
        final user = users.firstWhere((item) => item.id == _id);
        emit(UserLoaded(user));
      }
    });
  }

  void load(String id) {
    if (_id != id) {
      _id = id;
      emit(UserLoading(id));
      if (_repository.connected) {
        try {
          emit(UserLoaded(_repository.getUserById(id)));
        } catch (_) {
          emit(const UserError("Could not find todo"));
        }
      }
    }
  }
}

part of 'users_cubit.dart';

abstract class UsersState extends Equatable {
  const UsersState();
}

class UsersInitial extends UsersState {
  @override
  List<Object> get props => [];
}

class UsersLoading extends UsersState {
  @override
  List<Object?> get props => [];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}

class UsersLoaded extends UsersState {
  final Iterable<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

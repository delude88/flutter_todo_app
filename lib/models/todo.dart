import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String userId;

  const Todo({required this.id, required this.userId});

  Todo copyWith({String? userId}) =>
      Todo(id: id, userId: userId ?? this.userId);

  Todo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
      };

  @override
  List<Object?> get props => [id, userId];
}

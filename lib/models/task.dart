import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String todoId;
  final String text;

  const Task({required this.id, required this.todoId, required this.text});

  Task copyWith({String? todoId, String? text}) =>
      Task(id: id, todoId: todoId ?? this.todoId, text: text ?? this.text);

  Task.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        todoId = json['todoId'],
        text = json['text'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'todoId': todoId,
        'text': text,
      };

  @override
  List<Object?> get props => [id, todoId, text];
}

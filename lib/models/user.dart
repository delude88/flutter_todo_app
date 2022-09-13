import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;

  const User({required this.id, required this.name});

  User copyWith({String? name}) => User(id: id, name: name ?? this.name);

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}

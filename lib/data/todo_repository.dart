import 'dart:async';
import 'dart:convert';

import '../models/todo.dart';
import '../models/user.dart';
import 'socket_api.dart';

abstract class TodoRepository {
  final _listController = StreamController<List<Todo>>();
  final _connectedController = StreamController<bool>();

  bool get connected;

  Stream<Iterable<Todo>> get todos =>
      _listController.stream.asBroadcastStream();

  Stream<bool> get connection =>
      _connectedController.stream.asBroadcastStream();

  Todo getTodoById(String id);

  Iterable<Todo> getTodosByUser(User user);

  Iterable<Todo> getTodosByUserId(String userId);

  Iterable<Todo> getAllTodos();
}

class TodoRepositoryImpl extends TodoRepository {
  final SocketApi _api;
  final List<Todo> _list = [];
  bool _connected = false;

  TodoRepositoryImpl(this._api) {
    onAdd(payload) {
      _list.add(Todo.fromJson(payload));
      _listController.sink.add(_list);
    }

    onUpdate(payload) {
      final update = jsonDecode(payload);
      final id = update["id"];
      assert(id != null);
      final index = _list.indexWhere((it) => it.id == id);
      if (index != -1) {
        _list[index] = _list[index].copyWith(userId: update["userId"]);
      }
      _listController.sink.add(_list);
    }

    onRemove(payload) {
      assert(payload.runtimeType == String);
      _list.removeWhere((element) => element.id == payload);
      _listController.sink.add(_list);
    }

    _api.onConnect((data) {
      // Attach handlers
      _api.on("todo-added", onAdd);
      _api.on("todo-updated", onAdd);
      _api.on("todo-removed", onRemove);
      _connected = true;
      _connectedController.sink.add(_connected);
    });
    _api.onDisconnect((data) {
      // Disconnect handlers
      _api.off("todo-added", onAdd);
      _api.off("todo-updated", onUpdate);
      _api.off("todo-removed", onRemove);
      _connected = false;
      _connectedController.sink.add(_connected);
    });
  }

  @override
  Todo getTodoById(String id) =>
      _list.firstWhere((element) => element.id == id);

  @override
  Iterable<Todo> getTodosByUser(User user) => getTodosByUserId(user.id);

  @override
  Iterable<Todo> getTodosByUserId(String userId) =>
      _list.where((element) => element.userId == userId);

  @override
  Iterable<Todo> getAllTodos() => _list;

  @override
  bool get connected => _connected;
}

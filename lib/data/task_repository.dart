import 'dart:async';
import 'dart:convert';

import '../models/task.dart';
import '../models/todo.dart';
import 'socket_api.dart';

abstract class TaskRepository {
  final _listController = StreamController<List<Task>>();
  final _connectedController = StreamController<bool>();

  bool get connected;

  Stream<Iterable<Task>> get tasks =>
      _listController.stream.asBroadcastStream();

  Stream<bool> get connection =>
      _connectedController.stream.asBroadcastStream();

  Task getTaskById(String id);

  Iterable<Task> getTasksByTodo(Todo todo);

  Iterable<Task> getTasksByTodoId(String todoId);

  Iterable<Task> getAllTasks();
}

class TaskRepositoryImpl extends TaskRepository {
  final SocketApi _api;
  final List<Task> _list = [];
  bool _connected = false;

  TaskRepositoryImpl(this._api) {
    onAdd(payload) {
      _list.add(Task.fromJson(payload));
      _listController.sink.add(_list);
    }

    onUpdate(payload) {
      final update = jsonDecode(payload);
      final id = update["id"];
      assert(id != null);
      final index = _list.indexWhere((it) => it.id == id);
      if (index != -1) {
        _list[index] = _list[index]
            .copyWith(todoId: update["todoId"], text: update["text"]);
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
      _api.on("task-added", onAdd);
      _api.on("task-updated", onUpdate);
      _api.on("task-removed", onRemove);
      _connected = true;
      _connectedController.sink.add(_connected);
    });
    _api.onDisconnect((data) {
      // Disconnect handlers
      _api.off("task-added", onAdd);
      _api.off("task-updated", onUpdate);
      _api.off("task-removed", onRemove);
      _connected = false;
      _connectedController.sink.add(_connected);
    });
  }

  @override
  Task getTaskById(String id) =>
      _list.firstWhere((element) => element.id == id);

  @override
  Iterable<Task> getTasksByTodo(Todo todo) => getTasksByTodoId(todo.id);

  @override
  Iterable<Task> getTasksByTodoId(String todoId) =>
      _list.where((element) => element.todoId == todoId);

  @override
  Iterable<Task> getAllTasks() => _list;

  @override
  bool get connected => _connected;
}

import 'dart:async';
import 'dart:convert';

import '../models/user.dart';
import 'socket_api.dart';

abstract class UserRepository {
  final _listController = StreamController<List<User>>();
  final _connectedController = StreamController<bool>();

  bool get connected;

  Stream<Iterable<User>> get users =>
      _listController.stream.asBroadcastStream();

  Stream<bool> get connection =>
      _connectedController.stream.asBroadcastStream();

  Iterable<User> getAllUsers();

  User getUserById(String id);
}

class UserRepositoryImpl extends UserRepository {
  final SocketApi _api;
  final List<User> _list = [];
  bool _connected = false;

  UserRepositoryImpl(this._api) {
    onAdd(payload) {
      _list.add(User.fromJson(payload));
      _listController.sink.add(_list);
    }

    onUpdate(payload) {
      final update = jsonDecode(payload);
      final id = update["id"];
      assert(id != null);
      final index = _list.indexWhere((it) => it.id == id);
      if (index != -1) {
        _list[index] = _list[index].copyWith(name: update["name"]);
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
      _api.on("user-added", onAdd);
      _api.on("user-updated", onUpdate);
      _api.on("user-removed", onRemove);
      _connected = true;
      _connectedController.sink.add(_connected);
    });
    _api.onDisconnect((data) {
      // Disconnect handlers
      _api.off("user-added", onAdd);
      _api.off("user-updated", onUpdate);
      _api.off("user-removed", onRemove);
      _connected = false;
      _connectedController.sink.add(_connected);
    });
  }

  @override
  User getUserById(String id) {
    return _list.firstWhere((element) => element.id == id);
  }

  @override
  Iterable<User> getAllUsers() => _list;

  @override
  bool get connected => _connected;
}

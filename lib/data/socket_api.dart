import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef EventHandler<T> = dynamic Function(T data);

abstract class SocketApi {
  void onConnect(EventHandler handler);

  void onDisconnect(EventHandler handler);

  void on(String event, EventHandler handler);

  void once(String event, EventHandler handler);

  void off(String event, [EventHandler? handler]);
}

class SocketApiImpl extends SocketApi {
  final IO.Socket _socket;

  SocketApiImpl(String url) : _socket = IO.io(url);

  @override
  void on(String event, EventHandler handler) {
    _socket.on(event, (data) => null);
  }

  @override
  void once(String event, EventHandler handler) {
    _socket.once(event, handler);
  }

  @override
  void off(String event, [EventHandler? handler]) {
    _socket.off(event, handler);
  }

  @override
  void onConnect(EventHandler handler) {
    _socket.onConnect(handler);
  }

  @override
  void onDisconnect(EventHandler handler) {
    _socket.onDisconnect(handler);
  }
}

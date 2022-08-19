import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService extends ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  get serverStatus => _serverStatus;
  get socket => _socket;

  SocketService() {
    _init();
  }

  void _init() {
    _socket = IO.io('http://localhost:3001', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('event', (data) => print(data));

    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('message', (payload) {
      print('Nuevo mensaje: $payload');
    });
  }
}

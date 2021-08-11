import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/services/auth_service.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  late IO.Socket _socket;

  ServerStatus _serverStatus = ServerStatus.Connecting;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  void connect() async {
    final token = await AuthService.getToken();
    //IO.Socket socket;
    this._socket = IO.io(
        Enviromment.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setExtraHeaders({'x-token': token})
            // .enableForceNew()
            .build());

    this._socket.emit('mensaje', 'saludando desde flutter');
    //socket.on('connect', (data) => print('conectado desde flutter'));
    this._socket.onConnect((data) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (data) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}

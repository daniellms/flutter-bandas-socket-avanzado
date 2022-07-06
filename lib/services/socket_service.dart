import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Conecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Conecting;
  late IO.Socket _socket;

  ServerStatus get serverStatusGet => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() { // conexion
    _socket = IO.io('http://192.168.0.197:3000', {
      // asi viene 'http://localhost:3000/' sino levanta en vez de local
      //   192.168.0.197 ip de esta pc // alternativa 10.0.2.2 http://10.0.2.2:3000/

      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.onConnect((_) {
      log('connect');
      this._serverStatus = ServerStatus.Online;

      notifyListeners();
      // _socket.emit('msg', 'test');
    });
    // _socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) {
      log('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
      // socket.on('fromServer', (_) => print(_));
    });

    // nuestros metodos
    // socket.on('nuevo-mensaje', (payload) { // este es el q escucha aca
    //   log('nuevo-mensajito: ');
    //   log('nombre: ${payload['nombre']}');
    //   log('nombre: ${payload['mensaje']}');
    //   log(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no existe');
    //   // socket.on('fromServer', (_) => print(_));
    // });

    //dentro de algun boton un emit, osea manda alguna informacion, pero lo tiene q recivir el servidor
    // final socketService = Provider.of<SocketService>(context, listen: false); 
    // socketService.socket.emit('vote-band', {'id': banda.id}); 
  }
}

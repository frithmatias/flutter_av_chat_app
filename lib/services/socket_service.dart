import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as _io;

enum ServerStatus { onLine, offLine, connecting }

class SocketService with ChangeNotifier {
  // ChangeNotifier me va a ayudar a decirle al Provider cuando debe actualizar la UI
  // o algun widget en particular

  ServerStatus _serverStatus = ServerStatus.connecting;
  ServerStatus get serverStatus => _serverStatus;

  late _io.Socket _socket;
  _io.Socket get socket => _socket; // Getter para llamar la instancia socket desde afuera
  Function get emit => _socket.emit; // no es totalmente necesario pero podemos llamar a este getter para emitir

  // Constructor
  // SocketService() {
  //   _initConfig(); // Cuando se crea una instancia, este constructor corre _initConfig()
  // }
  
  // Ya no vamos a iniciar la conexión al crear una instancia del servicio, sino que lo vamos a llamar 
  // manualmente cuando el usuario hace un login exitoso, y también vamos a crear un metodo disconnect()
  // para desconectarlo manualmente cuando sea requerido.

  // void _initConfig() {
  void connect() async {

    // voy a llamar al método ESTATICO pero tengo que esperar porque sino voy a ver que en backend 
    // va a recibir 'x-token': "Instance of 'Future<String>'", en lugar del token.
    final token = await AuthService.getToken();

    _socket = _io.io(Environments.socketUrl,
        _io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew() // evita que el backend intente "recuperar" una conexión perdida
            .setExtraHeaders({'x-token': token})
            .build());

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.onLine;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offLine;
      notifyListeners();
    });

  }


  void disconnect(){
    _socket.disconnect();
  }
}

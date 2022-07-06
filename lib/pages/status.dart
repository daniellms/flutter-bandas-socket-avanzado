import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context); // un listener
    // socketService.socket.emit()



    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ServerStatus: ${socketService.serverStatusGet}')],
      )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: (){
            // esto se envia al servidor, y el servidor se encarga de reenviar a los demas clientes ver el servidor en su archivo socket.js
            socketService.socket.emit('emitir-mensaje', {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter'});  // aca es donde la aplicacion emite un msj para q lo escuche el servidor

          },
        ),
    );
  }
}

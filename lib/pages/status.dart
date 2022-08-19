import 'package:band_name_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Status extends StatelessWidget {
  const Status({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Text(
          socketService.serverStatus == ServerStatus.Online
              ? 'Online'
              : socketService.serverStatus == ServerStatus.Offline
                  ? 'Offline'
                  : 'Connecting',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          socketService.socket.emit('send-message', {
            'nombre': 'Flutter',
            'message': 'Hola desde Flutter',
          });
        },
      ),
    );
  }
}

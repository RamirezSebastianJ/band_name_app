import 'dart:io';

import 'package:band_name_app/models/band.dart';
import 'package:band_name_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  //initstate
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBand);

    super.initState();
  }

  _handleActiveBand(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromJson(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandsName', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Icon(
              socketService.serverStatus == ServerStatus.Online
                  ? Icons.check_circle
                  : socketService.serverStatus == ServerStatus.Offline
                      ? Icons.offline_bolt
                      : Icons.cloud_upload,
              color: socketService.serverStatus == ServerStatus.Online
                  ? Colors.green
                  : socketService.serverStatus == ServerStatus.Offline
                      ? Colors.red
                      : Colors.blue,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) {
          return _bandTitle(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTitle(int index) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(bands[index].id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': bands[index].id}),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('Delete'),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(bands[index].name.substring(0, 1)),
        ),
        title: Text(bands[index].name),
        trailing: Text('${bands[index].votes}'),
        onTap: () {
          socketService.socket.emit('vote-band', {'id': bands[index].id});
        },
      ),
    );
  }

  //addNewBand
  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: ((_) {
            return AlertDialog(
              title: const Text('New Band Name'),
              content: TextField(
                autofocus: true,
                controller: textController,
              ),
              actions: <Widget>[
                MaterialButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                MaterialButton(
                  child: const Text('Save'),
                  onPressed: () {
                    addBandToList(textController.text);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }));
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: const Text('New Band Name'),
              content: CupertinoTextField(
                autofocus: true,
                controller: textController,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('Save'),
                  onPressed: () {
                    addBandToList(textController.text);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('add-band', {'name': name});
    }
  }
}

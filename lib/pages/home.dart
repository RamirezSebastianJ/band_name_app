import 'package:band_name_app/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 10),
    Band(id: '2', name: 'Iron Maiden', votes: 5),
    Band(id: '3', name: 'Megadeth', votes: 1),
    Band(id: '4', name: 'Judas Priest', votes: 0),
    Band(id: '5', name: 'Iron Maiden', votes: 4),
    Band(id: '6', name: 'Megadeth', votes: 2),
    Band(id: '7', name: 'Judas Priest', votes: 1),
    Band(id: '8', name: 'Iron Maiden', votes: 3),
    Band(id: '9', name: 'Megadeth', votes: 0),
    Band(id: '10', name: 'Judas Priest', votes: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandsName', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) {
          return _bandTitle(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'home');
        },
      ),
    );
  }

  ListTile _bandTitle(int index) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(bands[index].name.substring(0, 1)),
      ),
      title: Text(bands[index].name),
      trailing: Text('${bands[index].votes}'),
      onTap: () {
        print('Band ${bands[index].name} was tapped!');
      },
    );
  }
}

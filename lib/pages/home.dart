import 'dart:developer';

import 'package:band_names/pages/models/banda.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Banda> bandas = [
    Banda(id: '1', nombre: 'Metallica', votos: 5),
    Banda(id: '2', nombre: 'Atom', votos: 5),
    Banda(id: '3', nombre: 'Frenships', votos: 2),
    Banda(id: '4', nombre: 'Remix', votos: 5),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // elevation: 1,
        title: const Text(
          'Nombre de Bandas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, backgroundColor: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: bandas.length,
        itemBuilder: (BuildContext context, int index) => _listTile(bandas[index]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: addNewBanda,
      ),
    );
  }

  Widget _listTile(Banda banda) {
    return Dismissible(
      key: Key(banda.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        log('direction: $direction');
        log('Id: ${ banda.id}');

        //TODO: LLAMAR EL BORRADO EN EL  SERVER

      },
      background: Container(
        padding: EdgeInsets.only(right: 250),
        color: Colors.red,
        child: const Center(
          child: Text(
            'Eliminar',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            banda.nombre!.substring(0, 2),
          ),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(banda.nombre!),
        trailing: Text(
          '${banda.votos}',
          style: TextStyle(
            fontSize: 20,
            // fontWeight: FontWeight.bold,
            // color: Colors.,
          ),
        ),
        onTap: () {
          log(banda.nombre!);
        },
      ),
    );
  }

  addNewBanda() {
    final textController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nuevo nombre de Banda'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  // un boton se puede agregar mas de uno
                  child: Text('Agregar'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => agregarALista(textController.text)), // se obtiene los que se escribio en la caja de texto
              // MaterialButton( // un boton se puede agregar mas de uno
              // child: Text('Agregar'),
              // elevation: 5,
              // textColor: Colors.blue,
              // onPressed: () => agregarALista(textController.text)),
              // log(textController.text) ,
            ],
          );
        });
  }

  void agregarALista(String nombre) {
    log(nombre);
    if (nombre.length > 1) {
      this.bandas.add(Banda(id: DateTime.now.toString(), nombre: nombre, votos: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}

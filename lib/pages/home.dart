import 'dart:developer';

import 'package:pie_chart/pie_chart.dart';
import 'package:band_names/pages/models/banda.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // esta lista se lleno primeramente de forma manual, ahora es llenada ñpor el servidor
  List<Banda> bandas = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    // socketService.socket.   tengo metodos
    socketService.socket.on('active-bands', _metodoLocalActiveBands);
    super.initState();
  }

  _metodoLocalActiveBands(dynamic payload) {
    // escucha
    bandas = (payload as List).map((band) => Banda.fromMap(band)).toList();

    setState(() {});
  }

  @override
  void dispose() {
    // con ete ya hacemos la limpieza
    final socketService = Provider.of<SocketService>(context, listen: false);
    // socketService.socket.   tengo metodos
    socketService.socket.off('active-bands');
    super.dispose();
  }

  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    // log('${socketService.serverStatusGet}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatusGet == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.green[200])
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
            // estos cambian de color dependiendo la conexion, pero cambian solos gracias a provider
          )
        ],
        title: const Text(
          'Nombre de Bandas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, backgroundColor: Colors.white),
        ),
      ),
      body: Column(
        children: [
          if (bandas.isNotEmpty) _showGraphiC(),
          Expanded(
            child: ListView.builder(
              itemCount: bandas.length,
              itemBuilder: (BuildContext context, int index) => _listTile(bandas[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: addNewBanda,
      ),
    );
  }

  Widget _listTile(Banda banda) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      // deslizable para eliminar
      key: Key(banda.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        // log('direction: $direction');
        // log('Id: ${banda.id}');
        socketService.socket.emit('delete-band', {'id': banda.id});
      },
      background: Container(
        padding: const EdgeInsets.only(right: 250),
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
          style: const TextStyle(
            fontSize: 20,
            // fontWeight: FontWeight.bold,
            // color: Colors.,
          ),
        ),
        onTap: () {
          final socketService = Provider.of<SocketService>(context, listen: false);
          // socketService.socket.   tengo mas metodos con  el .
          socketService.socket.emit('vote-band', {'id': banda.id}); // emite, manda o habla al servidor
          // log(banda.id!);
        },
      ),
    );
  }

  addNewBanda() {
    final textController = TextEditingController();

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Nuevo nombre de Banda'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  // un boton se puede agregar mas de uno
                  child: const Text('Agregar'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => agregarALista(textController.text)), // se obtiene los que se escribio en la caja de texto
              // log(textController.text) ,
            ],
          );
        });
  }

  void agregarALista(String nombre) {
    // log(nombre);

    if (nombre.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      // this.bandas.add(Banda(id: DateTime.now.toString(), nombre: nombre, votos: 0)); // esto era para verlos cambios de manera local
      // setState(() {}); NO OLVIDARSE SINO REDIBUJA
      // provider listen en false emitir add-band {name: name} esto vamos a emitir

      socketService.socket.emit('add-band', {'nombre': nombre});
      // escucha
      //   socketService.socket.on('add-band', (data) {
      //   // escucha
      //   bandas = (data as List).map((band) => Banda.fromMap(band)).toList();

      // });
    }

    Navigator.pop(context);
  }

  Widget _showGraphiC() {
    Map<String, double> dataMap = {
      // 'Flutter': 5, // valores estaticos
      // 'React': 3,
      // 'Xamarin': 2,
      // 'Ionic': 2,
    };

    //cargo el mapa de arriba q esta vacio con una forEach de la lista bandas
    bandas.forEach((banda) {
      dataMap.putIfAbsent(banda.nombre!, () => banda.votos!.toDouble());
    });

    // return Container(  // implementacion funcional basica
    //   width: double.infinity,
    //    height: 200, child:
    //  PieChart(dataMap: dataMap),);

    final List<Color> colorList = [
      Colors.blue,
      Colors.green[200]!,
      Colors.yellow,
      Colors.red,
      Colors.orange,
      Colors.red[200]!,
      Colors.blue[200]!,

    ];

    return Container(
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 1200),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 1.2, // cambiamos tamaño
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          // centerText: "HYBRID",
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            // legendShape: _BoxShape.circle,
            legendTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true, // porcentaje
            showChartValuesOutside: false,
            decimalPlaces: 0, // mostrar decimal en 1
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ));
  }
}

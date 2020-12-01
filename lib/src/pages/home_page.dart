import 'package:flutter/material.dart';
import 'package:ia_images/src/providers/db_provider.dart';

import 'package:ia_images/src/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key key}) : super//(key: key);
  final pieStyle = TextStyle(fontSize: 13.0, color: Colors.grey[500]);

  final Color colorRosa = Color.fromRGBO(237, 0, 140, 1);

  @override
  Widget build(BuildContext context) {

    //Pruba DB
    //DBProvider.db.database;

    //ScanModel nuevoScan = new ScanModel(valor: '21|1|9|599|1|C|0|72');
    //DBProvider.db.newScan(nuevoScan);
    //DBProvider.db.getScanById(6).then((scan) => print(scan.valor));
    //DBProvider.db.getScans().then((value) => print(value));
    //ScanModel nuevoScan = new ScanModel(id:6, valor: 'editado');
    //DBProvider.db.updateScan(nuevoScan ).then((value) => print(value));
    //DBProvider.db.deleteScan(6);
    //DBProvider.db.deleteScanAll().then(print);


    // Obtener el tamaño de los medios de comunicación actuales
    final _screenSize = MediaQuery.of(context).size;   
    return Scaffold(
      appBar: _appBar(context),
      body: ListView(
        children: [
          _tituloPrincipal(),
          _campos(),
          _botonQR(_screenSize),
          _piePagina()
        ],
      ),
    );
  }

  Widget _tituloPrincipal() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Text('Casilla',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)))
    ]);
  }

  Widget _campos() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoCasilla('Estado', 'Chihuahua'),
          _infoCasilla('Distrito', '1'),
          _infoCasilla('Tipo de Acta', '2'),
          _infoCasilla('Sección', '540'),
          _infoCasilla('Casilla', 'E1'),
        ],
      ),
    );
  }

  _infoCasilla(String texto, String data) {
    return Column(
      children: [
        Text(texto,
            style: TextStyle(
              fontSize: 10,
            )),
        Container(
            padding: EdgeInsets.symmetric(vertical: 10.0), child: Text(data)),
      ],
    );
  }

  Widget _botonQR(_screenSize) {
    return ScanButton();
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/img/Imagotipo.png',
            ),
            Text('Captura de votos',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            IconButton(
              icon: Icon(Icons.exit_to_app, color: colorRosa, size: 24.0),
              onPressed: () => _mostrarAlerta(context),
            )
          ],
        ));
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Center(
                child: Text('Cerrar Sesión',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    child: Text('¿Seguro que deseas cerrar sesión?',
                        style: TextStyle(
                          fontSize: 15.0,
                        ))),
                Divider()
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Seguir aqui',
                          style: TextStyle(color: colorRosa))),
                  FlatButton(
                      onPressed: null,
                      child: Text('|', style: TextStyle(color: colorRosa))),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      child: Text('Salir', style: TextStyle(color: colorRosa))),
                ],
              ),
            ],
          );
        });
  }

  Widget _piePagina() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),    
      child: Center(child: Text('INE | 2020 Todos los derechos son reservados', style: pieStyle)),
    );
  }

}

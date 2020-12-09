//import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ia_images/src/models/scan_model.dart';
//import 'package:ia_images/src/providers/db_provider.dart';
import 'package:ia_images/src/providers/scan_list_provider.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super//(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ScanModel scanModel = new ScanModel();
  ScanListProvider scanListProvider = new ScanListProvider();

  String barcodeScanRes;

  bool _botonQr = true;
  bool _botonFoto = false;

  File foto;
  final picker = ImagePicker();

  final pieStyle = TextStyle(fontSize: 13.0, color: Colors.grey[500]);

  final Color colorRosa = Color.fromRGBO(237, 0, 140, 1);

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de los medios de comunicación actuales
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(context),
      body: ListView(
        children: [
          _tituloPrincipal(),
          _campos(),
          _botonQR(_screenSize),
          _botonImage(_screenSize),
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
        Text(texto, style: TextStyle(fontSize: 10)),
        Container(
            padding: EdgeInsets.symmetric(vertical: 10.0), child: Text(data)),
      ],
    );
  }

  Widget _botonQR(_screenSize) {
    return Visibility(
      visible: _botonQr,
      child: Container(
        margin: EdgeInsets.only(top: (_screenSize.height * 0.6)),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.5,
            color: colorRosa,
            textColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
              child: Text('Escanear'),
            ),
            onPressed: _tomarQR),
      ),
    );
  }

  Widget _botonImage(_screenSize) {
    return Visibility(
      visible: _botonFoto,
      child: Container(
        margin: EdgeInsets.only(top: (_screenSize.height * 0.6)),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.5,
            color: colorRosa,
            textColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
              child: Text('Capturar'),
            ),
            onPressed: _tomarFoto),
      ),
    );
  }

  void _tomarQR() async {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ED008C', 'Cancelar', false, ScanMode.QR);
    print('escaneo: $barcodeScanRes');
    if (barcodeScanRes != '-1') {
      print('escaneo if: $barcodeScanRes');
      setState(() {
        _botonQr = false;
        _botonFoto = true;
        scanModel.valor = barcodeScanRes;
      });
    }
  }

  void _tomarFoto() async {
    print("tomar foto");
    _procesarImagen(ImageSource.camera);
    setState(() { });    
  }

  void _procesarImagen(ImageSource origin) async {
    print('procesar imagen');
    final pickedFile = await picker.getImage(source: origin);

    setState(() {
      if (pickedFile != null) {
        foto = File(pickedFile.path);
        print(foto);        
      }      
    });

    if (foto != null ) {
      scanModel.fotoUrl = await scanListProvider.subirImagen(foto);
      print('===============================');
      print(scanModel.valor);
      print( scanModel.fotoUrl);
      print('===============================');
      foto = null;
      _botonFoto = false;
    }

    setState(() { });

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
      child: Center(
          child: Text('INE | 2020 Todos los derechos son reservados',
              style: pieStyle)),
    );
  }
}

//import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ia_images/src/models/scan_model.dart';
//import 'package:ia_images/src/providers/db_provider.dart';
import 'package:ia_images/src/providers/scan_list_provider.dart';
import 'package:ia_images/src/providers/image_ia_provider.dart';

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
  ImageIAProvider imageProvider = new ImageIAProvider();

  String barcodeScanRes;
  bool _botonQr = true;
  bool _botonFoto = false;
  File foto;
  bool isEnabled = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  final List<dynamic> test = [];
  final Color colorRosa = Color.fromRGBO(237, 0, 140, 1);
  final pieStyle = TextStyle(fontSize: 13.0, color: Colors.grey[500]);
  final tituloTabla =  TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);

  enableButton() {
    setState(() {
      isEnabled = true;
    });
  }

  disableButton() {
    setState(() {
      isEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de los medios de comunicación actuales
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(context),
      body: ListView(
        children: [
          _tituloPrincipal(),
          _campos(),
          _botonQR(_screenSize),
          _botonImage(_screenSize),
          _tablaVotos(),
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
    return StreamBuilder(
      stream: scanListProvider.infoCasillaStream,
      //initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoCasilla('Estado',
                  snapshot.hasData ? snapshot.data[0].toString() : '?'),
              _infoCasilla('Distrito',
                  snapshot.hasData ? snapshot.data[1].toString() : '?'),
              _infoCasilla('Tipo de Acta',
                  snapshot.hasData ? snapshot.data[2].toString() : '?'),
              _infoCasilla('Sección',
                  snapshot.hasData ? snapshot.data[3].toString() : '?'),
              _infoCasilla('Casilla',
                  snapshot.hasData ? snapshot.data[4].toString() : '?'),
            ],
          ),
        );
      },
    );
  }

  _infoCasilla(String texto, data) {
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.5,
          color: colorRosa,
          textColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
            child: Text('Capturar'),
          ),
          onPressed: isEnabled ? _tomarFoto : null,
        ),
      ),
    );
  }

  void _tomarQR() async {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ED008C', 'Cancelar', false, ScanMode.QR);
    scanListProvider.dataCasilla(barcodeScanRes);
    if (barcodeScanRes != '-1') {
      mostrarSnackbar('Codigo QR procesado');
      setState(() {
        _botonQr = false;
        _botonFoto = true;
        scanModel.valor = barcodeScanRes;
      });
    }
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
    setState(() {});
  }

  void _procesarImagen(ImageSource origin) async {
    final pickedFile = await picker.getImage(source: origin);

    setState(() {
      if (pickedFile != null) {
        foto = File(pickedFile.path);
        mostrarSnackbar('Imagen procesandose');
        disableButton();
      }
    });

    if (foto != null) {
      scanModel.fotoUrl = await scanListProvider.subirImagen(foto);
      final test = await imageProvider.partidoData();
      foto = null;
      _botonFoto = false;
    }
    setState(() {});
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

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Container(child: Text(mensaje)),
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 2000),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _tablaVotos() {
    if (imageProvider.partidos.length > 0) {
      print('if');
      return Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Text('Votacion', style: tituloTabla,)
                ),
            ],
          ),
          
          DataTable(
          columns: const <DataColumn>[
          DataColumn(label: Text('REPRESENTACIÓN')),
          DataColumn(label: Text('LETRA')),
          DataColumn(label: Text('NÚMERO')),
        ], rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Sarah')),
              DataCell(Text('19')),
              DataCell(Text('Student')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Sarah')),
              DataCell(Text('19')),
              DataCell(Text('Student')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Sarah')),
              DataCell(Text('19')),
              DataCell(Text('Student')),
            ],
          ),
        ]),

        ] 
      );
    } else {
      print('else');
      return Container();
    }
  }
}

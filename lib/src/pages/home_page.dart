//import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ia_images/src/models/scan_model.dart';
import 'package:ia_images/src/providers/db_provider.dart';
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
  bool _botonEnviar = false;
  bool _tablaVotosData = true;
  bool _bloquearPartido = false;
  bool _bloquearCandidatura = false;
  bool _bloquearCoalicion = false;
  bool _bloquearCandidatosNo = false;
  bool _bloquearVotosNulos = false;
  bool _bloquearTotal = false;
  File foto;
  bool isEnabled = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  final List<dynamic> test = [];
  final Color colorRosa = Color.fromRGBO(237, 0, 140, 1);
  final pieStyle = TextStyle(fontSize: 13.0, color: Colors.grey[500]);
  final tituloTabla = TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
  final subtituloTabla = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

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
          _tablaVotos(_screenSize),
          _botonEnviarLista(_screenSize),
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

  void _checkList() {
    if(_bloquearPartido && _bloquearCandidatura && _bloquearCoalicion && _bloquearCandidatosNo && _bloquearVotosNulos && _bloquearTotal){
      enableButton();       
    }
    else{
      disableButton();
    }
    setState(() {});
  }

  void _procesarInformacion() {
     _checkList();  
    Navigator.pushReplacementNamed(context, 'ready'); 
    _botonEnviar = false;  
    _tablaVotosData = false; 
  }

  Widget _botonEnviarLista(_screenSize) {    
    return Visibility(
      visible: _botonEnviar,
      child: Container(
       // margin: EdgeInsets.only(top: (_screenSize.height * 0.6)),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.5,
          color: colorRosa,
          textColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
            child: Text('Enviar'),
          ),
          onPressed: isEnabled ? _procesarInformacion : null,
        ),
      ),
    );
  }  

  _procesarQR() async {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ED008C', 'Cancelar', false, ScanMode.QR);
    final qr = await scanListProvider.dataCasilla(barcodeScanRes);
    print('barcodeScanRes: $qr');    
  }

  void _tomarQR() async {
    await _procesarQR();
   
    if (barcodeScanRes != '-1') {
      mostrarSnackbar('Codigo QR procesado');
       // Insertar codigo QR en sqlite
        final tempScan = new ScanModel(valor: barcodeScanRes);
        await  DBProvider.db.newScan(tempScan);

        // Obtener el total de registros insertados
        final listaScans = await DBProvider.db.getScans();
        // Obtener la ultima posicion de la tabla scans
        final id = listaScans.length;
        // Obtener el ultimo registro
        final scanQR = await DBProvider.db.getScanById(id);
        final ultimoQR = scanQR.valor;
        print('scanQR: $ultimoQR');
        setState(() {
        _botonQr = false;
        _botonFoto = true;        
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
      await scanListProvider.subirImagen(foto);
      await imageProvider.dataImage();
      
      foto = null;
      _botonFoto = false;
      _botonEnviar = true;
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

  Widget _tablaVotos(_screenSize) {
    //final List<Map<String, String>> listOfColumns = imageProvider.partidos;
    final List<dynamic> listaPartidos = imageProvider.partidos;
    final List<dynamic> listaCandidatura = imageProvider.candidaturaComun;
    final List<dynamic> listaCoalicion = imageProvider.coalicion;
    final List<dynamic> listaCandidatos = imageProvider.candidatosNoRegistrados;
    final List<dynamic> listaVotosNulos = imageProvider.votosnulos;
    final List<dynamic> listaTotal = imageProvider.total;

    if (imageProvider.partidos.length > 0 ){
      return Visibility(
        visible: _tablaVotosData,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Text(
                    'Votacion',
                    style: tituloTabla,
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: colorRosa,
                    ),
                    child: CheckboxListTile(
                        activeColor: colorRosa,
                        checkColor: Colors.white,
                        title: Text('Partidos', style: subtituloTabla),
                        value: _bloquearPartido,
                        onChanged: (valor) {
                          setState(() {
                            _bloquearPartido = valor;
                            _checkList();
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('REP...')),
                DataColumn(label: Text('LETRA')),
                DataColumn(
                    label: Text(
                  'NÚM...',
                  overflow: TextOverflow.ellipsis,
                )),
              ],
              rows:
                  listaPartidos // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                        ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 0.0),
                                    width: _screenSize.width * 0.1,
                                    child: Image(
                                        image: NetworkImage(element[
                                            "rutalogopartido"])))), //Extracting from Map element the value
                                DataCell(Container(
                                  width: _screenSize.width * 0.4,
                                  child: TextFormField(
                                    initialValue: element["texto"],
                                    onSaved: (value) => element["texto"] = value,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Ingresar valor';
                                      }
                                      if (value.length < 3) {
                                        return 'El valor requiere mas de dos caracteres';
                                      }
                                      return null;
                                    },
                                  ),
                                )),
                                DataCell(Container(
                                  width: _screenSize.width * 0.1,
                                  child: TextFormField(
                                    initialValue: element["numero"],
                                    onSaved: (value) => element["numero"] = value,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Ingresar valor';
                                      }
                                      if (value.length < 3) {
                                        return 'El valor requiere mas de dos caracteres';
                                      }
                                      return null;
                                    },
                                  ),
                                )),
                              ],
                            )),
                      )
                      .toList(),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: colorRosa,
                    ),
                    child: CheckboxListTile(
                        activeColor: colorRosa,
                        checkColor: Colors.white,
                        title: Text('Candidatura común', style: subtituloTabla),
                        value: _bloquearCandidatura,
                        onChanged: (valor) {
                          setState(() {
                            _bloquearCandidatura = valor;
                            _checkList();
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('REP...')),
                DataColumn(label: Text('LETRA')),
                DataColumn(
                    label: Text(
                  'NÚM...',
                  overflow: TextOverflow.ellipsis,
                )),
              ],
              rows:
                  listaCandidatura // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                        ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 0.0),
                                    width: _screenSize.width * 0.1,
                                    child: Image(
                                        image: NetworkImage(element[
                                            "rutalogopartido"])))), //Extracting from Map element the value
                                DataCell(Container(
                                  width: _screenSize.width * 0.4,
                                  child: TextFormField(
                                    initialValue: element["texto"],
                                    onSaved: (value) => element["texto"] = value,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Ingresar valor';
                                      }
                                      if (value.length < 3) {
                                        return 'El valor requiere mas de dos caracteres';
                                      }
                                      return null;
                                    },
                                  ),
                                )),
                                DataCell(Container(
                                  width: _screenSize.width * 0.1,
                                  child: TextFormField(
                                    initialValue: element["numero"],
                                    onSaved: (value) => element["numero"] = value,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Ingresar valor';
                                      }
                                      if (value.length < 3) {
                                        return 'El valor requiere mas de dos caracteres';
                                      }
                                      return null;
                                    },
                                  ),
                                )),
                              ],
                            )),
                      )
                      .toList(),
            ),
          ),
           Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: colorRosa,
                    ),
                    child: CheckboxListTile(
                        activeColor: colorRosa,
                        checkColor: Colors.white,
                        title: Text('Coalición', style: subtituloTabla),
                        value: _bloquearCoalicion,
                        onChanged: (valor) {
                          setState(() {
                            _bloquearCoalicion = valor;
                            _checkList();
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
           Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: DataTable(
              columns: const <DataColumn>[
              DataColumn(label: Text('REP...')),
              DataColumn(label: Text('LETRA')),
              DataColumn(label: Text('NÚM...', overflow:  TextOverflow.ellipsis,)),
          ], rows: listaCoalicion // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                                width: _screenSize.width * 0.1,                            
                                child: Image(
                                  image: NetworkImage( element["rutalogopartido"])
                                  )
                                )      
                            ), //Extracting from Map element the value
                            DataCell(
                              Container(
                                width: _screenSize.width * 0.4,
                                child: TextFormField(
                                  initialValue: element["texto"],
                                  onSaved: (value) => element["texto"] = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ingresar valor';
                                    }
                                    if (value.length < 3) {
                                      return 'El valor requiere mas de dos caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ),
                            DataCell(
                              Container(
                                width: _screenSize.width * 0.1,
                                child: TextFormField(
                                  initialValue: element["numero"],
                                  onSaved: (value) => element["numero"] = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ingresar valor';
                                    }
                                    if (value.length < 3) {
                                      return 'El valor requiere mas de dos caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ),
                          ],
                        )),
                  )
                  .toList(),
            ),
          ),
           Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: colorRosa,
                    ),
                    child: CheckboxListTile(
                        activeColor: colorRosa,
                        checkColor: Colors.white,
                        title: Text('Candidatos/as no registrad...', style: subtituloTabla),
                        value: _bloquearCandidatosNo,
                        onChanged: (valor) {
                          setState(() {
                            _bloquearCandidatosNo = valor;
                            _checkList();
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
           Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: DataTable(
              columns: const <DataColumn>[
              DataColumn(label: Text('LETRA')),
              DataColumn(label: Text('NÚM...', overflow:  TextOverflow.ellipsis,)),
          ], rows: listaCandidatos // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                           //Extracting from Map element the value
                            DataCell(
                              Container(
                                width: _screenSize.width * 0.6,
                                child: TextFormField(
                                  initialValue: element["texto"],
                                  onSaved: (value) => element["texto"] = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ingresar valor';
                                    }
                                    if (value.length < 3) {
                                      return 'El valor requiere mas de dos caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ),
                            DataCell(
                              Container(
                                width: _screenSize.width * 0.1,
                                child: TextFormField(
                                  initialValue: element["numero"],
                                  onSaved: (value) => element["numero"] = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ingresar valor';
                                    }
                                    if (value.length < 3) {
                                      return 'El valor requiere mas de dos caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ),
                          ],
                        )),
                  )
                  .toList(),
            ),
          ),
           Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: colorRosa,
                    ),
                    child: CheckboxListTile(
                        activeColor: colorRosa,
                        checkColor: Colors.white,
                        title: Text('Votos nulos', style: subtituloTabla),
                        value: _bloquearVotosNulos,
                        onChanged: (valor) {
                          setState(() {
                            _bloquearVotosNulos = valor;
                            _checkList();
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
           Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: DataTable(
              columns: const <DataColumn>[
              DataColumn(label: Text('LETRA')),
              DataColumn(label: Text('NÚM...', overflow:  TextOverflow.ellipsis,)),
          ], rows: listaVotosNulos // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[                        
                            DataCell(
                              Container(
                                width: _screenSize.width * 0.6,
                                child: TextFormField(
                                  initialValue: element["texto"],
                                  onSaved: (value) => element["texto"] = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ingresar valor';
                                    }
                                    if (value.length < 3) {
                                      return 'El valor requiere mas de dos caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ),
                            DataCell(
                              Container(
                                width: _screenSize.width * 0.1,
                                child: TextFormField(
                                  initialValue: element["numero"],
                                  onSaved: (value) => element["numero"] = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ingresar valor';
                                    }
                                    if (value.length < 3) {
                                      return 'El valor requiere mas de dos caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ),
                          ],
                        )),
                  )
                  .toList(),
            ),
          ),
           Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: colorRosa,
                    ),
                    child: CheckboxListTile(
                        activeColor: colorRosa,
                        checkColor: Colors.white,
                        title: Text('Total', style: subtituloTabla),
                        value: _bloquearTotal,
                        onChanged: (valor) {
                          setState(() {
                            _bloquearTotal = valor;
                            _checkList();
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
           Container(
            padding: EdgeInsets.only(bottom: 30.0),
            child: DataTable(
              columns: const <DataColumn>[
              DataColumn(label: Text('LETRA')),
              DataColumn(label: Text('NÚM...', overflow:  TextOverflow.ellipsis,)),
          ], rows: listaTotal // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[     
                            DataCell(
                              Container(
                                width: _screenSize.width * 0.6,
                                child: TextFormField(
                                  initialValue: element["texto"],
                                  onSaved: (value) => element["texto"] = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ingresar valor';
                                    }
                                    if (value.length < 3) {
                                      return 'El valor requiere mas de dos caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ),
                            DataCell(
                              Container(
                                width: _screenSize.width * 0.1,
                                child: TextFormField(
                                  initialValue: element["numero"],
                                  onSaved: (value) => element["numero"] = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ingresar valor';
                                    }
                                    if (value.length < 3) {
                                      return 'El valor requiere mas de dos caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ),
                          ],
                        )),
                  )
                  .toList(),
            ),
          ),
        ]),
      );
    } else {
      // print('else');
      return Container();
    }
  }

  
}

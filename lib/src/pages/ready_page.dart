import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReadyPage extends StatelessWidget {
  //const ListoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(237, 0, 140, 1),
          border: Border.all(
            color: Theme.of(context).accentColor,
          )),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icono(),
            _titulo(),
            _subtitulo('Enviaste la  lista'),
            _subtitulo('de votos tu casilla'),
            _botonEntendido(context, _screenSize),
            _piePagina(),
          ],
        )
      ]),
    ));
  }

  Widget _icono() {
    return Container(
      margin: EdgeInsets.only(top: 160 ),  
      child: Icon(Icons.check, size: 80, color: Colors.white)
      );
  }

  Widget _titulo() {
    return Text('¡Listo!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          height: 3.0,
        ));
  }

  Widget _subtitulo(texto) {
    return Text(texto,
        style: TextStyle(color: Colors.white, fontSize: 15.0, height: 2.0));
  }

  Widget _botonEntendido(BuildContext context, _screenSize) {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 140),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.5,
          color: Colors.white,
          textColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: _screenSize.width * 0.3, vertical: 15.0),
            child: Text('Entendido',
                style: TextStyle(
                    fontSize: 15.0, 
                    color: Color.fromRGBO(237, 0, 140, 1),
                    fontWeight: FontWeight.bold
                    )
                    ),
          ),
          onPressed: () {
            bool botonQr = false;
            bool votosEnviados = true;
            Navigator.pushReplacementNamed(context, 'home', arguments: {'botonQr': botonQr, 'votosEnviados': votosEnviados }); 
          }),
    );
  }

  Widget _piePagina() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Center(
          child: Text('INE | 2020 Todos los derechos son reservados',
              style: TextStyle(fontSize: 13.0, color: Colors.white)),
        ));
  }
}

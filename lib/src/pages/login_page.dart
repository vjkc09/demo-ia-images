import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //const HomePage({Key key}) : super//(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de los medios de comunicación actuales
    final size = MediaQuery.of(context).size;
    // Obtener la orientacion del dispositivo
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Stack(
      children: <Widget>[
        _crearFondo(size, orientation),
       // _loginForm(context, size),
      ],
    ),
    );
  }

    Widget _crearFondo(size, orientation) {
    final fondo = Container(
      height: (orientation == Orientation.portrait ) ?  size.height * 0.40 :  size.height * 0.60 , 
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(179, 0, 102, 1.0),
        Color.fromRGBO(237, 0, 140, 1.0)
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    final logo = Container(
      padding: EdgeInsets.only(top: 60.0),
      child: Column(
        children: [          
          Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 100.0,
          ), 
          SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          Text(
            'Captura de Votos',
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          )
        ],
      ),
    );

    return Stack(
      children: [
        fondo,
        Positioned(top: 180.0, left: 30.0, child: circulo),
        Positioned(top: -30.0, right: -30.0, child: circulo),
        logo
      ],
    );
  }
}



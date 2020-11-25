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
        _loginForm(context, size),
      ],
    ),
    );
  }

    Widget _crearFondo(size, orientation) {
    final fondo = Container(
      height: (orientation == Orientation.portrait ) 
      ?  size.height * 0.40 :  size.height * 0.60 , 
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

  Widget _loginForm(BuildContext context, size) {
    //final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
              height: 200.0,)
            ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 40.0),
                _crearEmail(),
                SizedBox(height: 30.0),
                _crearPassword(),
                SizedBox(height: 30.0),
                _crearBoton(),
              ],
            ),
          ),
          SizedBox(height: 30.0),
          FlatButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'registro'),
              child: Text('Crear Usuario')),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearEmail() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.alternate_email,
                    color: Colors.pinkAccent,
                  ),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Correo electronico',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: null,
            ),
          );
        });
  }

  Widget _crearPassword( ) {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock_outline,
                    color: Colors.pinkAccent,
                  ),
                  labelText: 'Contraseña',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
             // onChanged: (value) => changePassword(value),
            ),
          );
        });
  }


  Widget _crearBoton() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.5,
            color: Colors.pinkAccent,
            textColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
              child: Text('Iniciar'),
            ),
           // onPressed: snapshot.hasData ? () => _login(context, bloc) : null,
          );
        });
  }

  /* _login(BuildContext context, LoginBloc bloc) async {
    Map info = await usuarioProvider.login(bloc.email, bloc.password);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      utils.mostrarAlerta(context, info['mensaje']);
    }
  } */

}



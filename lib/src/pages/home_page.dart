import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key key}) : super//(key: key);

  final Color colorRosa = Color.fromRGBO(237, 0, 140, 1);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Image.asset('assets/img/Imagotipo.png',),
            Text('Captura de votos', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,  color: Colors.black)),
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: colorRosa,
                size: 24.0               
              ),
              onPressed: () =>  _mostrarAlerta(context),
            )
          ],
          )
      ),
      body:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
          ],
        ),
    );
  }

   void _mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          title: Center(child: Text('Cerrar Sesión', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Text('¿Seguro que deseas cerrar sesión?', style: TextStyle(fontSize: 15.0,))),
              Divider()
            ],
          ),
          actions: [              
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(onPressed: () => Navigator.of(context).pop(), 
                child: Text('Seguir aqui', style: TextStyle(color: colorRosa))),
                FlatButton(onPressed: null, child: Text('|', style: TextStyle(color: colorRosa))),
                FlatButton(onPressed: () {
                  Navigator.pushReplacementNamed(context, 'login');
                }, child: Text('Salir', style: TextStyle(color: colorRosa))),
              ],
            ),  
          ],
        );
      }
    );
  }


}

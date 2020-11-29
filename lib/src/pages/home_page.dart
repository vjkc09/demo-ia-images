import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key key}) : super//(key: key);

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
            Icon(
              Icons.exit_to_app,
              color: Color.fromRGBO(237, 0, 140, 1),
              size: 24.0
              
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
}

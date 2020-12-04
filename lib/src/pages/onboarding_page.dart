//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OnBoardingPage extends StatefulWidget {
  //const OnBoardingPage({Key key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  // Colores boton
  final Color colorRosa = Color.fromRGBO(237, 0, 140, 1);
  final Color colorGris = Colors.grey;
  // Estilos pie de pagina
  final pieStyle = TextStyle(fontSize: 13.0, color: Colors.grey[500]);
  // Bandear habilitar boton
  bool _isButtonDisabled = false;

  // Imagenes Widget _swiperTarjetas
  final imageList = [
    'assets/img/group_27.png',
    'assets/img/group_28.png',
    'assets/img/group_30.png',
  ];


  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de los medios de comunicación actuales
    final _screenSize = MediaQuery.of(context).size;     

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
            children: [
              _logoINE(_screenSize),
              _swiperTarjetas(context, _screenSize),
               SizedBox(
                    height:  _screenSize.height * 0.15,
                  ),
              _boton(context, _screenSize),
              _piePagina(),
            ],
        ),
      )
    );
  }

  Widget _logoINE(_screenSize) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: _screenSize.height * 0.2,
        child: Image.asset(
        'assets/img/logoINE-01.png',
        width: 120.0,
        ),
    );
  }
  // Metodo para manejar color boton comenzar
  _colorBoton() {
    if (_isButtonDisabled) {
       return colorRosa;
    }
    setState(() {});
    return colorGris;
  }

  Widget _boton(BuildContext context, _screenSize) {
    return Visibility(
      child: Container(
        child: RaisedButton(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.5,
            color: _colorBoton() ,
            textColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 85.0, vertical: 15.0),
              child: Text('Comenzar'),
            ),
            onPressed: () {
              if (_isButtonDisabled) {
                  Navigator.pushReplacementNamed(context, 'home');
              }
              setState(() {                
              });
            }
            ),
      ),
    );
  }

  Widget _piePagina() {
    return Container(
      padding: EdgeInsets.only(top: 30.0),    
      child: Text('INE | 2020 Todos los derechos son reservados', style: pieStyle),
    );
  }

  Widget _swiperTarjetas(BuildContext context, _screenSize) {
    return Container(
          padding: EdgeInsets.only(top: 20.0),
          width: _screenSize.width * 0.75,
          height: _screenSize.height * 0.5,
          
          child: Swiper(
          layout: SwiperLayout.DEFAULT,
          itemWidth: _screenSize.width * 0.9,
          itemHeight: _screenSize.height * 0.9,
          itemCount: 3,
                onIndexChanged: (index) {
                  //debugPrint("index:$index");                   
                  if (index == 2) {
                      _isButtonDisabled = true;              
                                         
                  }else {
                      _isButtonDisabled = false;
                  }

                  setState(() { });
                },
                onTap: (index) {
                  debugPrint("Clicked on: $index");
                },
          pagination: SwiperPagination(   
            builder: DotSwiperPaginationBuilder(
                activeColor: Colors.pinkAccent,
                color: Colors.black54,
                
            ),
          ),
          itemBuilder: (BuildContext context,int index){
            return  Container(
              padding: EdgeInsets.only(bottom: 30.0),
                          child: Image.asset(
              imageList[index],
              fit: BoxFit.fill,
              ),
            );
          },          
        ),
    );
  }
}
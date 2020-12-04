//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OnBoardingPage extends StatelessWidget {
  //const OnBoardingPage({Key key}) : super(key: key);

  final pieStyle = TextStyle(fontSize: 13.0, color: Colors.grey[500]);
  // Arreglo de imagenes
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
                    height:  _screenSize.height * 0.2,
                  ),
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
                  /* debugPrint("index:$index");
                   if(index == 2) {
                   Timer(Duration(seconds: 10) , () {
                     Navigator.pushReplacementNamed(context, 'home');
                   });
                  } */
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
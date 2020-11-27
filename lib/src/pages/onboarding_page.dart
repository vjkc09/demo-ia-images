import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OnBoardingPage extends StatelessWidget {
  //const OnBoardingPage({Key key}) : super(key: key);

  final pieStyle = TextStyle(fontSize: 13.0, color: Colors.grey[500]);

  final imageList = [
    'assets/img/humaaans_phone.png',
    'assets/img/humaaans_space.png',
    'assets/img/humaaans_wireframe.png',
  ];

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;     

    return Scaffold(
      body: Column(
          /* crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end, */
          children: [
            _logoINE(_screenSize),
            _swiperTarjetas(context, _screenSize),
            _piePagina(),
          ],
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
          width: double.infinity ,
          height: _screenSize.height * 0.7,
          
          child: Swiper(
          layout: SwiperLayout.DEFAULT,
          itemWidth: _screenSize.width * 0.8,
          itemHeight: _screenSize.height * 0.5,
          itemCount: 3,
          scrollDirection: Axis.horizontal,
                //loop: true,
                //duration: 1000,
                //autoplay: true,
                onIndexChanged: (index) {
                  debugPrint("index:$index");
                  if(index == 2) {
                   Timer(Duration(seconds: 5) , () {
                     Navigator.pushReplacementNamed(context, 'home');
                   });
                  }
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
          autoplayDisableOnInteraction : true,
          itemBuilder: (BuildContext context,int index){
            return  Image.asset(
            imageList[index],
            fit: BoxFit.fill,
            );
          },          
          //control: new SwiperControl(),
        ),
    );
  }
}
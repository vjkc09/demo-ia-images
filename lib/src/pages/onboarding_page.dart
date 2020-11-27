import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OnBoardingPage extends StatelessWidget {
  //const OnBoardingPage({Key key}) : super(key: key);

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
      //crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            _swiperTarjetas(_screenSize)
          ],
      )
    );
  }


  Widget _swiperTarjetas(_screenSize) {
    return Container(
          padding: EdgeInsets.only(top: 50.0),
          width: double.infinity,
          height: _screenSize.height * 0.9,
          child: Swiper(
          //layout: SwiperLayout.STACK,
          //layout: SwiperLayout.TINDER,
          itemWidth: _screenSize.width * 0.8,
          itemHeight: _screenSize.height * 0.5,
          //viewportFraction: 0.8,
          //scale: 0.9,
          itemBuilder: (BuildContext context,int index){
            return  Image.asset(
            imageList[index],
            fit: BoxFit.fill,
            );
          },
          itemCount: 3,
          pagination: SwiperPagination(            
            builder: DotSwiperPaginationBuilder(
                activeColor: Colors.pinkAccent,
                color: Colors.black54,
            )
        )
          //control: new SwiperControl(),
        ),
    );
  }
}
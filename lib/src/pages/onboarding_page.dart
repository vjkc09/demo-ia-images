import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OnBoardingPage extends StatelessWidget {
  //const OnBoardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Onboarding'),
            Divider(),
            _swiperTarjetas(_screenSize)
          ],
      )
    );
  }


  Widget _swiperTarjetas(_screenSize) {
    return Container(
          padding: EdgeInsets.only(top: 10.0),
          width: double.infinity,
          height: 300.0,
          child: Swiper(
          //layout: SwiperLayout.STACK,
          layout: SwiperLayout.TINDER,
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context,int index){
            return new Image.network("http://via.placeholder.com/350x150",
            fit: BoxFit.fill,
            );
          },
          itemCount: 3,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
        ),
    );
  }
}
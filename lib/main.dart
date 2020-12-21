import 'package:flutter/material.dart';

import 'package:ia_images/src/bloc/provider.dart';

import 'package:ia_images/src/pages/home_page.dart';
import 'package:ia_images/src/pages/ready_page.dart';
import 'package:ia_images/src/pages/login_page.dart';
import 'package:ia_images/src/pages/onboarding_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
          child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'login' : (BuildContext context) => LoginPage(),
          'onboarding' : (BuildContext context) => OnBoardingPage(),
          'home' : (BuildContext context) => HomePage(),
          'ready' : (BuildContext context) => ReadyPage()
        },
         theme: ThemeData(primaryColor: Colors.pinkAccent),
      ),
    );
  }
}
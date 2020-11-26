import 'package:flutter/material.dart';
import 'package:ia_images/src/bloc/provider.dart';
import 'package:ia_images/src/pages/home_page.dart';
import 'package:ia_images/src/pages/login_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
          child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login' : (BuildContext context) => LoginPage(),
          'home' : (BuildContext context) => HomePage()
        },
         theme: ThemeData(primaryColor: Colors.pinkAccent),
      ),
    );
  }
}
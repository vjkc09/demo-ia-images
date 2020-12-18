import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class ImageIAProvider {
  List<dynamic> partidos = [];
  List<dynamic> candidaturacComun = [];
  List<dynamic> coalicion = [];
  List<dynamic> candidatosNoRegistrados = [];
  List<dynamic> votosnulos = [];
  List<dynamic> total = [];
  // ignore: empty_constructor_bodies
  ImageIAProvider(){}

  Future<List<dynamic>> partidoData() async{
    final res = await rootBundle.loadString('data/imagen.json');
    Map partidoMap = json.decode(res);
    print(partidoMap['partido']);
    partidos = partidoMap['partido'];
    return partidos;
  }




}
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class ImageIAProvider {
  //List<Map<String, String>> partidos = [];
  List<dynamic> partidos = [];
  List<dynamic> candidaturaComun = [];
  List<dynamic> coalicion = [];
  List<dynamic> candidatosNoRegistrados = [];
  List<dynamic> votosnulos = [];
  List<dynamic> total = [];
  // ignore: empty_constructor_bodies
  ImageIAProvider(){}

  Future<List<dynamic>> partidoData() async{
    final res = await rootBundle.loadString('data/imagen.json');
    Map partidoMap = json.decode(res);
    partidos = partidoMap['partido'];
    return partidos;
  }

  Future<List<dynamic>> candidaturaData() async{
    final res = await rootBundle.loadString('data/imagen.json');
    Map candidaturaMap = json.decode(res);
    candidaturaComun = candidaturaMap['candidaturacomun'];    
    return candidaturaComun;
  }

  Future<List<dynamic>> coalicionData() async{
    final res = await rootBundle.loadString('data/imagen.json');
    Map coalicionMap = json.decode(res);
    coalicion = coalicionMap['coalicion'];
    return coalicion;
  }

  Future<List<dynamic>> candidatosData() async{
    final res = await rootBundle.loadString('data/imagen.json');
    Map candidatosMap = json.decode(res);
    candidatosNoRegistrados = candidatosMap['candidatosnoregistrados'];
    return candidatosNoRegistrados;
  }

  Future<List<dynamic>> votosNulosData() async{
    final res = await rootBundle.loadString('data/imagen.json');
    Map votosMap = json.decode(res);
    votosnulos = votosMap['votosnulos'];
    return votosnulos;
  }

  Future<List<dynamic>> totalData() async{
    final res = await rootBundle.loadString('data/imagen.json');
    Map totalMap = json.decode(res);
    total = totalMap['total'];
    return total;
  }

  dataImage() async {
    await partidoData();
    await candidaturaData();
    await coalicionData();
    await candidatosData();
    await votosNulosData();
    await totalData();
  }


}
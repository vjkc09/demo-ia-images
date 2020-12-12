import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:mime_type/mime_type.dart';

class ScanListProvider {

  // Arreglo para inicializar estados
  List<dynamic> infoCasilla = [];

  dataCasilla(String data) async {
    print("===============================");
    print('data: $data');
    infoCasilla = data.split('|');
    print('info: $infoCasilla');    
    print(infoCasilla[0]);
    print("===============================");

    cargarDataEstados();

  }

  void cargarDataEstados() {

    rootBundle.loadString('data/estados.json')
                .then((value) => print(value));
  }

// Subir imagen
  Future<String> subirImagen(File imagen ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/vjkc09/image/upload?upload_preset=c66e9x5x');
    final mimeType = mime(imagen.path).split('/');

    // Peticion Cloudinary
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    // Adjuntar archivo a la peticion
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    // Validando estado de la respuesta
    if (resp.statusCode != 200 && resp.statusCode != 201) {
 
      print('Algo salio mal');
      print(resp.body);
      return null;      
    }

    final respData = jsonDecode(resp.body);
    print('respData: $respData');
    
    return respData['secure_url'];
    
  }

  
}
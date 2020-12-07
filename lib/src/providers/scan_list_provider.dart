import 'dart:io';

import 'package:mime_type/mime_type.dart';

class ScanListProvider {

// Subir imagen
  Future<String> subirImagen(File imagen ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/vjkc09/image/upload?upload_preset=c66e9x5x');
    final mimeType = mime(imagen.path).split('/');
    
  }
  
}
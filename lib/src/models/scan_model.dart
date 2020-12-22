// To parse this JSON data, do
//
//     final scanModel = scanModelFromJson(jsonString);

import 'dart:convert';
//import 'package:meta/meta.dart'; 


ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
    ScanModel({
        this.id,
        //@required this.valor,
        this.valor,
    });

    int id;
    String valor;


    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        valor: json["valor"],
  
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "valor": valor,

    };
}

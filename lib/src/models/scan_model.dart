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
        this.fotoUrl
    });

    int id;
    String valor;
    String fotoUrl;


    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        valor: json["valor"],
        fotoUrl: json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "valor": valor,
        "fotoUrl": fotoUrl,
    };
}

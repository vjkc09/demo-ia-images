import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:ia_images/src/models/scan_model.dart';
export 'package:ia_images/src/models/scan_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {

     // Path DB en dispositivo fisico
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);
    ///data/user/0/com.example.ia_images/app_flutter/ScansDB.db

    // Crear DB
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE Scans (
            id INTEGER PRIMARY KEY,
            valor TEXT
            )
        ''');
      },
    ); 
  }

  // CREAR Registros
  Future<int> newScanRaw(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.rawInsert('''
        INSERT INTO Scans (id, valor) 
        VALUES (${nuevoScan.id}, '${nuevoScan.valor}') 
    ''');
    return res;
  }

  Future<int> newScan( ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson() );
    print(res);
    // Id del ultimo registro insertado
    return res;
  }

  // SELECT - Obtener Informacion
  Future<ScanModel> getScanById( int id) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty 
              ? ScanModel.fromJson(res.first) 
              : null;

  }

  Future<List<ScanModel>> getScans() async {
    // Get de referencia a la DB
    final db = await database;

    // Query obtener todos los registros
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                              ? res.map((s) => ScanModel.fromJson(s) ).toList()
                              : [];
    return list;

  }




}
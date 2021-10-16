import 'dart:io';

import 'package:listschool/src/models/tareas_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  static final _nombreBD = "TAREASBD";
  static final _versionBD = 4;
  static final _nombreTBL = "tblTareas";

  static Database? _database;
  Future<Database?> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaBD = join(carpeta.path,_nombreBD);
    return openDatabase(
        rutaBD,
        version: _versionBD,
        onCreate: _crearTabla
    );
  }

  Future<void> _crearTabla(Database db, int version) async{
    await db.execute("CREATE TABLE $_nombreTBL (idTarea INTEGER PRIMARY KEY, nomTarea VARCHAR(50), dscTarea VARCHAR(100), fechaEntrega VARCHAR(50), entregada VARCHAR(2) )");
  }

  Future<int> insert(Map<String,dynamic> row) async{
    var conexion = await database;
    return conexion!.insert(_nombreTBL, row);
  }

  Future<int> update(Map<String, dynamic> row) async{
    var conexion = await database;
    return conexion!.update(_nombreTBL, row, where: 'idTarea = ?', whereArgs: [row['idTarea']]); //whereArgs: [row['id']]);
  }

  Future<int> delete (int idTarea) async{
    var conexion = await database;
    return await conexion!.delete(_nombreTBL, where: 'idTarea = ?', whereArgs: [idTarea]);
  }
  Future<List<TareasModel>> getAllTareas() async{
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL);
    return result.map((notaMap) => TareasModel.fromMap(notaMap)).toList();
  }

  Future<TareasModel> getTarea(int id) async{
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL, where: 'id = ?', whereArgs: [id]);
    //result.map((notaMap) => NotasModel.fromMap(notaMap)).first;
    return TareasModel.fromMap(result.first);
  }

}
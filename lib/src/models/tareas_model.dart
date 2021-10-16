import 'package:flutter/cupertino.dart';

class TareasModel{
  int? idTarea;
  String? nomTarea;
  String? dscTarea;
  String? fechaEntrega;
  String? entregada;

/*NotasModel(int id, String titulo, String detalle){
  this.id = id;
  this.titulo = titulo;
  this.detalle = detalle;
}*/

  TareasModel({this.idTarea,this.nomTarea,this.dscTarea, this.fechaEntrega, this.entregada});

//Map -> Object
  factory TareasModel.fromMap(Map<String,dynamic> map){
    return TareasModel(
        idTarea      :  map['idTarea'],
        nomTarea     :  map['nomTarea'],
        dscTarea     :  map['dscTarea'],
        fechaEntrega :  map['fechaEntrega'],
        entregada    :  map['entregada']
    );
  }

//Object -> Map
  Map<String,dynamic> toMap(){
    return{
      'idTarea'      : idTarea,
      'nomTarea'     : nomTarea,
      'dscTarea'     : dscTarea,
      'fechaEntrega' : fechaEntrega,
      'entregada'    : entregada
    };
  }



}
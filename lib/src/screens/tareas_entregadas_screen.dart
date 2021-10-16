import 'package:flutter/material.dart';
import 'package:listschool/src/database/database_helper.dart';
import 'package:listschool/src/models/tareas_model.dart';

import 'agregar_tarea_screen.dart';

class EntregadasScreen extends StatefulWidget {
  const EntregadasScreen({Key? key}) : super(key: key);

  @override
  _EntregadasScreenState createState() => _EntregadasScreenState();
}

class _EntregadasScreenState extends State<EntregadasScreen> {

  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tareas Entregadas'),
      ),
      body: FutureBuilder(
        future: _databaseHelper.getAllTareas(),
        builder: (BuildContext context, AsyncSnapshot<List<TareasModel>> snapshot){
          if(snapshot.hasError ){
            return Center(child: Text('Ocurrio un error en la petición'),);
          }else{
            if(snapshot.connectionState == ConnectionState.done){
              return _listadoTareas(snapshot.data!);
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },
      ),
    );
  }

  Widget _listadoTareas(List<TareasModel> tareas){
    return RefreshIndicator(
        onRefresh: (){
          return Future.delayed(
              Duration(seconds: 2),
                  (){ setState(() {}); }
          );

        },
        child: ListView.builder(
          itemBuilder: (BuildContext context, index){
            TareasModel tarea = tareas[index];
            if(tarea.entregada == "1"){
              return Card(
                child: Column(
                  children: [
                    Text(tarea.nomTarea!, style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(tarea.dscTarea!, style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(tarea.fechaEntrega! as String, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text("TAREA CONCLUIDA", style: TextStyle(fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: (){
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text('Confirmación'),
                                    content: Text('¿Estás seguro del borrado?'),
                                    actions: [
                                      TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                            _databaseHelper.delete(tarea.idTarea!).then(
                                                    (noRows){
                                                  if(noRows > 0){
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('El registro se ha eliminado'))
                                                    );
                                                    setState(() {});
                                                  }
                                                }
                                            );
                                          },
                                          child: Text('Si')
                                      ),
                                      TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text('No')
                                      )
                                    ],
                                  );
                                }
                            );
                          },
                          icon: Icon(Icons.delete),
                          iconSize: 18,
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
            return Card(
              child: Column(

              ),
            );
          },
          itemCount: tareas.length,
        )
    );
  }



}

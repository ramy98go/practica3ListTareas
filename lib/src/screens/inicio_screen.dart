import 'package:flutter/material.dart';
import 'package:listschool/src/database/database_helper.dart';
import 'package:listschool/src/models/tareas_model.dart';
import 'package:listschool/src/screens/agregar_tarea_screen.dart';
import 'package:listschool/src/screens/finalizar_screen.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({Key? key}) : super(key: key);

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {

  

  late DatabaseHelper _databaseHelper;
  DateTime _date = DateTime.now();


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
        title: Text('Mis Tareas'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/agregar').whenComplete(
                        () { setState( () {} ); }
                );
              },
              icon: Icon(Icons.note_add_rounded)
          )
        ],
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
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('ISC. Ramón Gómez'),
              accountEmail: Text('ramon1998pxndx@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://cdn1.vectorstock.com/i/1000x1000/31/95/user-sign-icon-person-symbol-human-avatar-vector-12693195.jpg'),
                child: Icon(Icons.verified_user),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            ListTile(
              title: Text('TAREAS ENTREGADAS'),
              subtitle: Text('Aquí puedes ver las tareas que has entregado'),
              leading: Icon(Icons.home_work),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/entregadas').whenComplete(
                        () { setState( () {} ); }
                );
              },
            ),
          ],
        ),
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
            DateTime ent = DateTime.parse(tarea.fechaEntrega as String);
            int diast = ent.difference(_date).inDays+1;
            if(tarea.entregada == "0"){
              if(DateTime.parse(tarea.fechaEntrega as String).isBefore(_date))
                {
                  return Card(
                    color: Colors.redAccent,
                    child: Column(
                      children: [
                        Text(tarea.nomTarea!, style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(tarea.dscTarea!, style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(tarea.fechaEntrega as String, style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text("TAREA RETRASADA ENVIAR LO ANTES POSIBLE", style: TextStyle(fontWeight: FontWeight.bold),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: Icon(Icons.send),
                              label: Text('Entregar Tarea'),
                              onPressed: (){
                                Navigator.push( context,
                                    MaterialPageRoute( builder: (context) => FinalizarScreen(tarea: tarea,))).then((value) {
                                  setState(() {

                                  });
                                });
                              },
                            ),
                            IconButton(
                              onPressed: (){
                                Navigator.push( context,
                                    MaterialPageRoute( builder: (context) => AgregarTareaScreen(tarea: tarea,))).then((value) {
                                  setState(() {

                                  });
                                });
                              },
                              icon: Icon(Icons.edit),
                              iconSize: 18,
                            ),
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
                }else {
                return Card(
                  child: Column(
                    children: [
                      Text(tarea.nomTarea!,
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(tarea.dscTarea!,
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(tarea.fechaEntrega! as String,
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(diast != null ? 'Quedan: $diast días para la entrega' : "Ya no hay días",
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.send),
                            label: Text('Entregar Tarea'),
                            onPressed: () {
                              Navigator.push( context,
                                  MaterialPageRoute( builder: (context) => FinalizarScreen(tarea: tarea,))).then((value) {
                                    setState(() {

                                    });
                              });
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push( context,
                                  MaterialPageRoute( builder: (context) => AgregarTareaScreen(tarea: tarea,))).then((value) {
                                setState(() {

                                });
                              });
                            },
                            icon: Icon(Icons.edit),
                            iconSize: 18,
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Confirmación'),
                                      content: Text(
                                          '¿Estás seguro del borrado?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _databaseHelper.delete(
                                                  tarea.idTarea!).then(
                                                      (noRows) {
                                                    if (noRows > 0) {
                                                      ScaffoldMessenger.of(
                                                          context).showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'El registro se ha eliminado'))
                                                      );
                                                      setState(() {});
                                                    }
                                                  }
                                              );
                                            },
                                            child: Text('Si')
                                        ),
                                        TextButton(
                                            onPressed: () {
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
            }
            return Container(
            );
          },
          itemCount: tareas.length,
        )

    );
  }


}



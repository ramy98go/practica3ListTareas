import 'package:flutter/material.dart';
import 'package:listschool/src/database/database_helper.dart';
import 'package:listschool/src/models/tareas_model.dart';
import 'package:listschool/src/screens/inicio_screen.dart';

class AgregarTareaScreen extends StatefulWidget {
  TareasModel? tarea;
  AgregarTareaScreen({Key? key, this.tarea}) : super(key: key);

  @override
  _AgregarTareaScreenState createState() => _AgregarTareaScreenState();
}

class _AgregarTareaScreenState extends State<AgregarTareaScreen> {

  late DatabaseHelper _databaseHelper;
  DateTime _date = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async{
   DateTime? _datePicker = await showDatePicker(
       context: context,
       initialDate: _date,
       firstDate: DateTime(1998),
       lastDate: DateTime(2030),
     initialDatePickerMode: DatePickerMode.year,
   );
   if(_datePicker != null && _datePicker != _date){
     setState(() {
       _date = _datePicker;
       _controllerfecha.text = _datePicker.toString();
     });
   }
  }

  TextEditingController _controllerNom = TextEditingController();
  TextEditingController _controllerDes = TextEditingController();
  TextEditingController _controllerfecha = TextEditingController();
  TextEditingController _controllerentregada = TextEditingController(text: "0");

  late String entregada;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    if( widget.tarea != null){
      _controllerNom.text = widget.tarea!.nomTarea!;
      _controllerDes.text = widget.tarea!.dscTarea!;
      _controllerfecha.text = widget.tarea!.fechaEntrega! as String;
      _controllerentregada.text = widget.tarea!.entregada as String;
    }
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.tarea == null ? Text('Agregar Tarea') : Text('Editar Tarea'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20,),
                _TextFieldNom(),
                SizedBox(height: 20,),
                _TextFormDes(),
                SizedBox(height: 20,),
               _TextFormFecha(),
                SizedBox(height: 20,),
                Visibility(
                  visible: false,
                  child: _TextFormEnt(),
                ),

                SizedBox(height: 20,),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.lightBlue,
                    child: Text('Guardar Tarea'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()){

                        if(widget.tarea == null) {
                          TareasModel tarea = TareasModel(
                              nomTarea: _controllerNom.text,
                              dscTarea: _controllerDes.text,
                              fechaEntrega: _controllerfecha.text,
                              entregada: _controllerentregada.text
                          );

                          _databaseHelper.insert(tarea.toMap()).then(
                                  (value) {
                                if (value > 0) {
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('La solicitud no se completo'))
                                  );
                                }
                              }
                          );
                        }else{
                          TareasModel nota = TareasModel(
                              idTarea: widget.tarea!.idTarea,
                              nomTarea: _controllerNom.text,
                              dscTarea: _controllerDes.text,
                              fechaEntrega: _controllerfecha.text,
                              entregada: "0"
                          );
                          _databaseHelper.update(nota.toMap()).then(
                                  (value) {
                                if(value > 0){
                                  Navigator.pop(context);
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('La solicitud no se completo'))
                                  );
                                }
                              });
                        }

                      }
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _TextFieldNom(){
    return TextFormField(
      controller: _controllerNom,
      validator: (val) => val!.isEmpty ?  "Campo Obligatorio" : null,
      autofocus: true,
      autocorrect: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nombre de la Tarea",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget _TextFormDes(){
    return TextFormField(
      controller: _controllerDes,
     // validator: (val) => val!.isEmpty ?  "Campo Obligatorio" : null,
      autofocus: true,
      autocorrect: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Descripción",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget _TextFormFecha(){
    return TextFormField(
      validator: (val) => val!.isEmpty ?  "Campo Obligatorio" : null,
      keyboardType: TextInputType.phone,
      autocorrect: false,
      controller: _controllerfecha,
      onTap: (){
        setState(() {
          _selectDate(context);
          FocusScope.of(context).requestFocus(new FocusNode());
        });
      },
      decoration: InputDecoration(
        labelText: 'Registration Date.',
        //filled: true,
        icon: const Icon(Icons.calendar_today),
        labelStyle:
        TextStyle(decorationStyle: TextDecorationStyle.solid),
      ),
    );
  }



  Widget _TextFormFecha1(){
    return TextFormField(
      controller: _controllerfecha,
      validator: (val) => val!.isEmpty ?  "Campo Obligatorio" : null,
      autofocus: true,
      autocorrect: true,
      keyboardType: TextInputType.datetime,
      onTap: (){
        setState(() {
          _selectDate(context);
        });
      },
      decoration: InputDecoration(
        labelText: 'Fecha de Entrega',
        hintText: (_date.toString()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget _TextFormEnt(){
    return TextFormField(
      controller: _controllerentregada,
      autofocus: true,
      autocorrect: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Tarea Entregada",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }



}

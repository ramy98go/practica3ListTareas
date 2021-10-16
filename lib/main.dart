import 'package:flutter/material.dart';
import 'package:listschool/src/screens/agregar_tarea_screen.dart';
import 'package:listschool/src/screens/bienvenida_screen.dart';
import 'package:listschool/src/screens/finalizar_screen.dart';
import 'package:listschool/src/screens/inicio_screen.dart';
import 'package:listschool/src/screens/tareas_entregadas_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/agregar'           : (BuildContext context) => AgregarTareaScreen(),
        '/finalizar'         : (BuildContext context) => FinalizarScreen(),
        '/entregadas'        : (BuildContext context) => EntregadasScreen()
      },
      debugShowCheckedModeBanner: false,
      home: BienvenidaScreen(),
    );
  }
}

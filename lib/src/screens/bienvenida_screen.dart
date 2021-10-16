import 'package:flutter/material.dart';
import 'package:listschool/src/screens/inicio_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';


class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: TareasScreen(),
      duration: 8000,
      imageSize: 150,
      text: 'Bienvenidos',
      backgroundColor: Colors.lightBlue,
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      colors: [
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.red
      ],
    );
  }
}

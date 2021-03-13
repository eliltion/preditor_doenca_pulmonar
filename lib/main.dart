import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/models/cart_model.dart';
import 'package:preditor_doenca_pulmonar/models/paciente_model.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:preditor_doenca_pulmonar/screens/home_screen.dart';
import 'package:preditor_doenca_pulmonar/screens/login_screen.dart';
import 'package:preditor_doenca_pulmonar/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child:  ScopedModel<PacienteModel>(
              model: PacienteModel(),
              child: MaterialApp(
                  title: 'P.D.P',
                  theme: ThemeData(
                      primarySwatch: Colors.blue,
                      primaryColor: Color.fromARGB(255, 4, 125, 141)
                  ),
                  home: HomeScreen(),
                  debugShowCheckedModeBanner: false
              ),
            )
          );
        },
      )
    );
  }
}

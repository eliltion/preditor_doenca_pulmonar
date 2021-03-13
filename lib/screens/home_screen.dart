import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/screens/paciente_screen.dart';
import 'package:preditor_doenca_pulmonar/tabs/home_tab.dart';
import 'package:preditor_doenca_pulmonar/tabs/paciente_tab.dart';
import 'package:preditor_doenca_pulmonar/widgets/custom_drawer.dart';
import 'package:preditor_doenca_pulmonar/datas/paciente_data.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';


import '../main.dart';
//import 'paciente_screenss.dart';


class HomeScreen extends StatelessWidget {
  final _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Pacientes"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: PacienteTab(),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>PacienteScreen())
              );
            },
            child: Icon(Icons.person),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        Container(color:  Colors.red,),
        Container(color:  Colors.blue,),
      ],
    );
  }

}
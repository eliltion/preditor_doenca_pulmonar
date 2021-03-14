import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:preditor_doenca_pulmonar/screens/login_screen.dart';
import 'package:preditor_doenca_pulmonar/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';


class CustomDrawer extends StatelessWidget {

  final PageController pageController;



  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 109, 109, 109)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          String tempo;
          var horario = DateTime.now().hour;
          if (horario >= 0 && horario <= 12)
            tempo = "Bom dia";
          else if(horario >13 && horario < 18)
            tempo = "Boa tarde";
          else
            tempo ="Boa noite";
          String nome = model.userData["nome"].toString();
          var nomeArray = nome.split(" ");
          print(nomeArray[0]);
          return Drawer(
            child: Stack(
              children: [
                _buildDrawerBack(),
                ListView(
                  padding: EdgeInsets.only(left: 32.0, top: 16.0),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                      height: 170.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 8.0,
                            left: 0.0,
                            child: Text("Predição \nDoença Pulmonar",
                              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),),
                          ),
                          Positioned(
                              left: 0.0,
                              bottom: 0.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${model.isLoggedIn() ? "${tempo} Dr. ${nomeArray[0]}" : "Olá"}",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      !model.isLoggedIn() ?
                                      "Entre ou cadastre-se"
                                          : "Sair",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    onTap: (){
                                      if(!model.isLoggedIn())
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=>LoginScreen())
                                        );
                                      else
                                        model.signOut();
                                    },
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.black, height: 3.0,),
                    DrawerTile(Icons.home, "Início", pageController, 0),
                    if(model.isLoggedIn())
                      DrawerTile(Icons.people, "Pacientes", pageController, 1),
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}

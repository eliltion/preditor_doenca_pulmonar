import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/models/paciente_model.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:preditor_doenca_pulmonar/tabs/paciente_tab.dart';
import 'package:preditor_doenca_pulmonar/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_screen.dart';

class PacienteScreen extends StatefulWidget {
  @override
  _PacienteScreenState createState() => _PacienteScreenState();
}


class _PacienteScreenState extends State<PacienteScreen> {

  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();

  final _icon = "https://firebasestorage.googleapis.com/v0/b/classificadordoencapulmonar.appspot.com/o/person.jpeg?alt=media&token=ea4bfa23-dd76-497f-b012-dc975ce420a4";

  final _formKey  = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Cadastro"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<PacienteModel>(
          builder: (context, child, model){
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.0,50.0,16.0, 0.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                        hintText: "Nome Completo"
                    ),
                    validator: (text){
                      if(text.isEmpty)
                        return "Nome Inválido";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _idadeController,
                    decoration: InputDecoration(
                        hintText: "Idade"
                    ),
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text.isEmpty )
                        return "Idade Inválida";
                    },
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Cadastrar Paciente",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          Map<String, dynamic> pacienteData = {
                            'nome' : _nomeController.text,
                            'idade' : _idadeController.text,
                            'icon' : _icon
                          };

                          model.signUp(
                              pacienteData: pacienteData,
                              onSuccess: _onSuccess,
                              onFail: _onFail
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        )
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Usuário criado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();

      //DrawerTile(this.icon, this.text, this.controller, this.page)

    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar usuário"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/models/paciente_model.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:preditor_doenca_pulmonar/tabs/home_tab.dart';
import 'package:preditor_doenca_pulmonar/tabs/paciente_tab.dart';
import 'package:preditor_doenca_pulmonar/tiles/drawer_tile.dart';
import 'package:preditor_doenca_pulmonar/tiles/paciente_tile.dart';
import 'package:preditor_doenca_pulmonar/widgets/custom_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_screen.dart';

class PacienteScreen extends StatefulWidget {
  @override
  _PacienteScreenState createState() => _PacienteScreenState();
}


class _PacienteScreenState extends State<PacienteScreen> {

  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  String _sexoController = 'Masculino';
  bool _isSelectedHipertenso = false;
  bool _isSelectedCardiaco = false;
  final _observacaoController = TextEditingController();

  final _icon = "https://firebasestorage.googleapis.com/v0/b/classificadordoencapulmonar.appspot.com/o/person.jpeg?alt=media&token=ea4bfa23-dd76-497f-b012-dc975ce420a4";

  final _formKey  = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DocumentSnapshot get doc => null;

  DocumentSnapshot snapshot;


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
                padding: EdgeInsets.fromLTRB(16.0,30.0,16.0, 0.0),
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
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _pesoController,
                    decoration: InputDecoration(
                        hintText: "Peso"
                    ),
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text.isEmpty )
                        return "Peso Inválido";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _alturaController,
                    decoration: InputDecoration(
                        hintText: "Altura"
                    ),
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text.isEmpty )
                        return "Altura Inválida";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  DropdownButton(
                    value: _sexoController,
                    icon: const Icon(Icons.person),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newvalue) {
                      setState(() {
                       _sexoController = newvalue;
                      });
                    },
                    items: <String>['Masculino', 'Feminino']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0,),
                  Row(
                    children: [
                      Text('Hipertenso'),
                      Checkbox(
                        value: _isSelectedHipertenso,
                        onChanged: (bool value) {
                          setState(() {
                            _isSelectedHipertenso = value;
                            print(_isSelectedHipertenso);
                          });
                        },
                      ),
                      Text('Cardíaco'),
                      Checkbox(
                        value: _isSelectedCardiaco,
                        onChanged: (bool value2) {
                          setState(() {
                            _isSelectedCardiaco = value2;
                            print(_isSelectedCardiaco);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _observacaoController,
                    decoration: InputDecoration(
                        hintText: "Obsercação"
                    ),
                    validator: (text){
                      if(text.isEmpty )
                        return "Observação Inválida";
                    },
                  ),
                  SizedBox(height: 30.0,),
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
                            'peso' : _pesoController.text,
                            'altura' : _alturaController.text,
                            'sexo' : _sexoController,
                            'hipertenso' : _isSelectedHipertenso,
                            'cardiaco' : _isSelectedCardiaco,
                            'observacao' : _observacaoController.text,
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
        SnackBar(content: Text("Paciente Cadastrado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );

    //Navigator.pushReplacement(
    //    context,
    //    MaterialPageRoute(
    //        builder: (BuildContext context) => super.widget));

    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop(context);
    });

  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao Cadastrar Paciente"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }
}


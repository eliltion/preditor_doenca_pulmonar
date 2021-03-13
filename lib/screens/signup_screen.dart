import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _crmController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _formKey  = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if(model.isLoading)
              return Center(child: CircularProgressIndicator(),);
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
                    controller: _cpfController,
                    decoration: InputDecoration(
                        hintText: "CPF"
                    ),
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text.isEmpty )
                        return "CPF Inválido";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _crmController,
                    decoration: InputDecoration(
                        hintText: "CRM"
                    ),
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text.isEmpty || text.contains("1234"))
                        return "CRM Inválido";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "Email"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text){
                      if(text.isEmpty || !text.contains("@"))
                        return "email Inválido";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ),
                    obscureText: true,
                    validator: (text){
                      if(text.isEmpty || text.length < 6) return "Senha Inválida";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                        hintText: "Confirmar Senha"
                    ),
                    obscureText: true,
                    validator: (text){
                      if(text.isEmpty || text.length < 6) return "Confirmação de Senha Inválida";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Criar Conta",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          Map<String, dynamic> userData = {
                            'nome' : _nomeController.text,
                            'cpf' : _cpfController.text,
                            'crm' : _crmController.text,
                            'email' : _emailController.text
                          };

                          model.signUp(
                              userData: userData,
                              pass: _senhaController.text,
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


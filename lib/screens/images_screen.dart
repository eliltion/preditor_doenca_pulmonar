import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:preditor_doenca_pulmonar/datas/classificacao.dart';
import 'package:preditor_doenca_pulmonar/datas/image_data.dart';
import 'package:preditor_doenca_pulmonar/datas/paciente_data.dart';
import 'package:preditor_doenca_pulmonar/models/paciente_model.dart';

import 'package:preditor_doenca_pulmonar/screens/pred_screen.dart';
import 'package:preditor_doenca_pulmonar/tiles/image_tile.dart';
import 'package:scoped_model/scoped_model.dart';



class ImagesScreen extends StatefulWidget {

  final DocumentSnapshot snapshot;

  ImagesScreen(this.snapshot);
  @override
  _ImagesScreenState createState() => _ImagesScreenState(snapshot);
}


class _ImagesScreenState extends State<ImagesScreen> {

  DocumentSnapshot snapshot;
  _ImagesScreenState(this.snapshot);

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

  @override
  void initState() {
    super.initState();

    _nomeController.text = snapshot.data["nome"];
    _idadeController.text = snapshot.data["idade"];
    _pesoController.text = snapshot.data["peso"];
    _alturaController.text = snapshot.data["altura"];
    _isSelectedHipertenso = snapshot.data["hipertenso"];
    _isSelectedCardiaco = snapshot.data["cardiaco"];
    _observacaoController.text = snapshot.data["observacao"];

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(snapshot.data["nome"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.person),),
                Tab(icon: Icon(Icons.grid_on),),
                Tab(icon: Icon(Icons.list),),
              ],
            ),
          ),
          body: ScopedModelDescendant<PacienteModel>(
            builder: (context, child, model){
              return FutureBuilder<QuerySnapshot>(
                future: Firestore.instance.collection("paciente").document(snapshot.documentID)
                    .collection("radio").getDocuments(),
                builder: (context, snap){
                  print(snap);
                  if(!snap.hasData)
                    return Center(child: CircularProgressIndicator(),);
                  else
                    return TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Form(
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
                                  width: 10.0,
                                  child: RaisedButton(
                                    child: Text("Atualizar",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    textColor: Colors.white,
                                    color: Theme.of(context).primaryColor,
                                    onPressed: (){

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
                                        model.updatePaciente(
                                            snapshot: snapshot,
                                            pacienteData: pacienteData,
                                            onSuccess: _onSuccess,
                                            onFail: _onFail
                                        );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),

                          GridView.builder(
                            padding: EdgeInsets.all(4.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                childAspectRatio: 0.65
                            ),
                            itemCount: snap.data.documents.length,
                            itemBuilder: (context, index){
                              return ImageTile("grid", ImageData.fromDocument(snap.data.documents[index]), snapshot);
                            },
                          ),
                          ListView.builder(
                              padding: EdgeInsets.all(4.0),
                              itemCount: snap.data.documents.length,
                              itemBuilder: (context, index){
                                return ImageTile("list", ImageData.fromDocument(snap.data.documents[index]), snapshot);
                              }
                          ),
                        ]
                    );
                },
              );
            },
          ),



          floatingActionButton: FloatingActionButton(
            onPressed: (){
              _s();
              _showOptions(context);
            },
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),

    );
  }

   Future _s()async{
     //DocumentSnapshot snap = await Firestore.instance.collection("paciente").document(snapshot.documentID).get();
     //print(snap.data["idade"]);
    QuerySnapshot snap = await Firestore.instance.collection("paciente").document("sOoHY7ZsqieeTP4ABVwh")
        .collection("radio").getDocuments();
      snap.documents.forEach((element) {
        print(element.data);
        print(element.documentID);
      });

  }

  void _showOptions(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Modelo embarcado 95% (Mobilinet)",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),),
                        onPressed: (){
                          ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
                            if(file == null) return;
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => PredScreen(file, "off", snapshot)));
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Modelo online 96% (Vgg16)",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),),
                        onPressed: (){
                            ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
                                if(file == null) return;
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => PredScreen(file, "on", snapshot)));
                            });

                            }
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Paciente Atualizado com sucesso!"),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        )
    );

  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao Cadastrar Usuário"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }

}

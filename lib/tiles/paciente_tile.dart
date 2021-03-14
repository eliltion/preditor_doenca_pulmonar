import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/models/cart_model.dart';
import 'package:preditor_doenca_pulmonar/screens/images_screen.dart';


class PacienteTile extends StatefulWidget {
  final DocumentSnapshot snapshot;

  PacienteTile(this.snapshot);

  @override
  _PacienteTileState createState() => _PacienteTileState(snapshot);
}

class _PacienteTileState extends State<PacienteTile> {

  DocumentSnapshot snapshot;

  _PacienteTileState(this.snapshot);


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9,0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(snapshot.data["icon"]),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(snapshot.data["nome"] ?? "",
                        style: TextStyle(fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Text("Idade: ${snapshot.data["idade"]}" ?? "",
                            style: TextStyle(fontSize: 12.0,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text("Peso: ${snapshot.data["peso"]}" ?? "",
                            style: TextStyle(fontSize: 12.0
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text("Sexo: ${snapshot.data["sexo"]}" ?? "",
                            style: TextStyle(fontSize: 12.0
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>ImagesScreen(snapshot))
          );
          //_showContactPage(contact: contacts[index]);
        },
      ),
      onDismissed: (direction){
        setState(() async {

          CartModel.of(context).removePaciente(snapshot.documentID);

          final snack = SnackBar(
            content: Text("Paciente ${snapshot.data["nome"]} será removido"),
            action: SnackBarAction(label: "Desfazer",
              onPressed: (){
                setState(() {
                 // _toDoList.insert((_lastRemovedPos), _lastRemoved);
                 // _saveData();
                });
              },
            ),
            duration: Duration(seconds: 5),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }
}



/*Widget _contacCard(BuildContext context, int index, snapshot){
  return GestureDetector(
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(snapshot.data["icon"]),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(snapshot.data["nome"] ?? "",
                    style: TextStyle(fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(snapshot.data["idade"] ?? "",
                    style: TextStyle(fontSize: 18.0
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    onTap: (){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ImagesScreen(snapshot))
      );
      //_showContactPage(contact: contacts[index]);
    },
  );

}*/

/*
ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["nome"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>ImagesScreen(snapshot))
        );
      },
    );
 */

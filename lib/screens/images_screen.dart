import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:preditor_doenca_pulmonar/datas/classificacao.dart';
import 'package:preditor_doenca_pulmonar/datas/image_data.dart';

import 'package:preditor_doenca_pulmonar/screens/pred_screen.dart';
import 'package:preditor_doenca_pulmonar/tiles/image_tile.dart';

class ImagesScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  ImagesScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["nome"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                //Tab(icon: Icon(Icons.person),),
                Tab(icon: Icon(Icons.grid_on),),
                Tab(icon: Icon(Icons.list),),
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("paciente").document(snapshot.documentID)
                .collection("radio").getDocuments(),
            builder: (context, snapshot){
              print(snapshot);
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator(),);
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    /*ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          return ImageTile("des", ImageData.fromDocument(snapshot.data.documents[index]));
                        }
                    ),*/
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65
                        ),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index){
                        return ImageTile("grid", ImageData.fromDocument(snapshot.data.documents[index]));
                      },
                    ),
                    ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          return ImageTile("list", ImageData.fromDocument(snapshot.data.documents[index]));
                        }
                    ),
                  ]
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
}

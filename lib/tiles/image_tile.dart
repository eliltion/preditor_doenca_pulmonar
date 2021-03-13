import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/datas/image_data.dart';
import 'package:preditor_doenca_pulmonar/screens/radio_screen.dart';

class ImageTile extends StatelessWidget {
  final String type;
  final ImageData image;

  final _nameController = TextEditingController();

  ImageTile(this.type, this.image);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RadioScreen(image)));
      },
      child: Card(
          child: _grade(type, context)
      ),
    );
  }
  
  Widget _grade(tela, context) {
    if (tela == "grid") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.8,
            child: Image.network(
              image.image,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "${image.classes[0]}: ${image.pesos[0].toStringAsFixed(2)}\n"
                        "${image.classes[1]}: ${image.pesos[1].toStringAsFixed(2)}\n"
                        "${image.classes[2]}: ${image.pesos[2].toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if(tela == "list") {
      return Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Image.network(
              image.image,
              fit: BoxFit.cover,
              height: 250.0,
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${image.data.toDate().day}/${image.data.toDate().month}/${image.data.toDate().year}\n",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${image.classes[0]}: ${image.pesos[0].toStringAsFixed(2)}\n"
                        "${image.classes[1]}: ${image.pesos[1].toStringAsFixed(2)}\n"
                        "${image.classes[2]}: ${image.pesos[2].toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\n\n${image.description}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: "Nome",
          labelStyle: TextStyle(color: Colors.blueAccent),
        ),
        onChanged: (text){
          //_userEdited = true;
          //setState(() {
          //  image.title = text;
          //});
        },
      );
    }
  }
}



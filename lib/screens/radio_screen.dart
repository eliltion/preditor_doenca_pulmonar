import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/datas/cart_product.dart';
import 'package:preditor_doenca_pulmonar/datas/image_data.dart';
import 'package:preditor_doenca_pulmonar/models/cart_model.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:preditor_doenca_pulmonar/screens/login_screen.dart';


class RadioScreen extends StatefulWidget {

  final ImageData image;
  DocumentSnapshot snapshot;

  RadioScreen(this.image, this.snapshot);
  @override
  _RadioScreenState createState() => _RadioScreenState(image, snapshot.documentID);
}

class _RadioScreenState extends State<RadioScreen> {

  bool _userEdited = false;
  final _dataController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ImageData image;
  String idPaciente;
  _RadioScreenState(this.image, this.idPaciente);

  String size;

  @override
  void initState() {
    super.initState();

    _descriptionController.text = image.description;

  }

  @override
  Widget build(BuildContext context) {

    var _data = ("${image.data.toDate().day}/${image.data.toDate().month}/${image.data.toDate().year}").toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(_data),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Image.network(
              image.image,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    maxLines: 5,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descricão",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    onChanged: (text){
                      _userEdited = true;
                      setState(() {
                        image.description = text;
                      });
                    },
                  ),

                ],
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          CartProduct cartProduct = CartProduct();
          cartProduct.description = _descriptionController.text;
          cartProduct.data = Timestamp.now();

          await CartModel.of(context).updateDescritionImage(cartProduct, image, idPaciente);

          Navigator.of(context).pop();
        },
        child: Icon(Icons.save),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

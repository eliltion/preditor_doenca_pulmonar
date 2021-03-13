import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/datas/image_data.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:preditor_doenca_pulmonar/screens/login_screen.dart';


class RadioScreen extends StatefulWidget {

  final ImageData image;

  RadioScreen(this.image);
  @override
  _RadioScreenState createState() => _RadioScreenState(image);
}

class _RadioScreenState extends State<RadioScreen> {

  bool _userEdited = false;
  final _dataController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ImageData image;
  _RadioScreenState(this.image);

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
        onPressed: (){
        },
        child: Icon(Icons.save),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

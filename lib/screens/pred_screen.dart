

import 'dart:ffi';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:preditor_doenca_pulmonar/datas/cart_product.dart';
import 'package:preditor_doenca_pulmonar/datas/image_data.dart';
import 'package:preditor_doenca_pulmonar/models/cart_model.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:preditor_doenca_pulmonar/screens/images_screen.dart';
import 'package:preditor_doenca_pulmonar/screens/login_screen.dart';
import 'package:tflite/tflite.dart';


class PredScreen extends StatefulWidget {

 // final ImageData image;
  File image;
  String metodo;

  final DocumentSnapshot snapshot;

  PredScreen(this.image, this.metodo, this.snapshot);
  @override
  _PredScreenState createState() => _PredScreenState(image, metodo, snapshot);
}

class _PredScreenState extends State<PredScreen>{


  List _outputs = [];
  List _pesosPredicao = [];
  List _classesPredicao = [];
 // File _image;
  bool _loading = false;
  String _search = "chirlene";

  AnimationController _colorAnimController;
  Animation _colorTween;


  bool _userEdited = false;
  final _descriptionController = TextEditingController();

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 8),
        () => "teste",
  );


  File image;
  String metodo;
  DocumentSnapshot snapshot;
  _PredScreenState(this.image, this.metodo, this.snapshot);

  String size;

  Future<Map> _getPredictions(File _image) async{
    String fileName = _image.path.split('/').last;
    Dio dio = new Dio();

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(_image.path, filename: fileName,),
    });

    await dio.post("http://10.0.2.2:43869/predict/image", data: data)
        .then((response) {
      print("aqui1");
      print(response.data);

      print("aqui2");
      print(response.data[0][0]);

      setState(() {
        _loading = false;
         Map v1 = {"confidence": response.data[0][1], "index": 0, "label": response.data[0][0]};
         Map v2 = {"confidence": response.data[1][1], "index": 1, "label": response.data[1][0]};
         Map v3 = {"confidence": response.data[2][1], "index": 2, "label": response.data[2][0]};

        _outputs.add(v1);
        _outputs.add(v2);
        _outputs.add(v3);

       // _outputs.sort((a,b) => a._outputs[0]["confidence"].isAfter(b._outputs[1]["confidence"])? -1: 1);

      });
    })
        .catchError((error) => print(error));

    print("assd");
    print(_outputs);
  }

  @override
   initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
      print("Modelo Carregado");
    });

    _pesosPredicao.clear();
    _classesPredicao.clear();
    _outputs.clear();

    if(metodo == "off") {
      classifyImage(image);
    }else {
      classifyImageAPI(image);
    }

  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/converted_model.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

Future classifyImageAPI(File image)  async {

   //var output = await _getPredictions(image);
  await _getPredictions(image).then((map){

  });

    setState(() {
      _loading = false;
      //_outputs = map;
    });


  }

Future classifyImage(File image) async {
   // _outputs.clear();
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 127,
        imageStd: 255 ,
        numResults: 3,
        threshold: 0.0,
        asynch: true
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });

  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {

    setState(() {
      _loading = true;

    });
  }
  /*pickImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(_image);
    classifyImageAPI(image);
  }*/

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Predição"),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: _calculation,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              image == null ? Container() : Image.file(image),
              SizedBox(
                height: 20,
              ),
              //image == null ? Container() : _outputs != null ?
              Text(
                '${_outputs[0]["label"]} ( ${(_outputs[0]["confidence"] * 100.0).toStringAsFixed(2)} % )',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              LinearPercentIndicator(
                lineHeight: 14.0,
                progressColor: Theme.of(context).primaryColor,
                percent: _outputs[0]["confidence"],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '${_outputs[1]["label"]} ( ${(_outputs[1]["confidence"] * 100.0).toStringAsFixed(2)} % )',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              LinearPercentIndicator(
                lineHeight: 14.0,
                progressColor: Theme.of(context).primaryColor,
                percent: _outputs[1]["confidence"],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '${_outputs[2]["label"]} ( ${(_outputs[2]["confidence"] * 100.0).toStringAsFixed(2)} % )',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              LinearPercentIndicator(
                lineHeight: 14.0,
                progressColor: Theme.of(context).primaryColor,
                percent: _outputs[2]["confidence"],
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
                          //image.description = text;
                        });
                      },
                    ),
                    SizedBox(height: 16.0,),
                  ],
                ),
              ),
            ];
          }else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Aguardando processamento...'),
              )
            ];
          }return ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children
                ),
              ),
            ],
          );
        }

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          var peso1 = _outputs[0]["confidence"]*100;
          var peso2 = _outputs[1]["confidence"]*100;
          var peso3 = _outputs[2]["confidence"]*100;

          _pesosPredicao.add(peso1);
          _pesosPredicao.add(peso2);
          _pesosPredicao.add(peso3);

          var classe1 = _outputs[0]["label"];
          var classe2 = _outputs[1]["label"];
          var classe3 = _outputs[2]["label"];

          _classesPredicao.add(classe1);
          _classesPredicao.add(classe2);
          _classesPredicao.add(classe3);

          CartProduct cartProduct = CartProduct();
          cartProduct.description = _descriptionController.text;
          cartProduct.pesos = _pesosPredicao;
          cartProduct.classes = _classesPredicao;
          cartProduct.data = Timestamp.now();

          await CartModel.of(context).addCartItem(cartProduct, snapshot, image);

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> ImagesScreen(snapshot))
          );

        },
        child: Icon(Icons.save),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

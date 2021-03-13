import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

//import 'package:image/image.dart' as imglib;

import 'dart:math' as Math;
import 'dart:convert';


//const request = "http://10.0.2.2:43869/predict/chirlene";

class Classificacao extends StatefulWidget {
  @override
  _TensorflowState createState() => _TensorflowState();
}

class _TensorflowState extends State<Classificacao> {

  List _outputs;
  File _image;
  bool _loading = false;
  String _search = "chirlene";

  AnimationController _colorAnimController;
  Animation _colorTween;

  //http.Response response;
  //response = await http.get("http://10.0.2.2:43869/items/$_texto");
  //response = await http.get("http://10.0.2.2:43869/items/$_texto");

  Future<Map> _getPredictions(File _image) async{
    String fileName = _image.path.split('/').last;
    Dio dio = new Dio();
    
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(_image.path, filename: fileName,),
    });

    dio.post("http://10.0.2.2:43869/predict/image", data: data)
        .then((response) => print(response))
        .catchError((error) => print(error));
  }

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/converted_model.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  classifyImageAPI(File image) async {
    String _nome = "Chirlene";

    _getPredictions(image).then((map){
      print(map);
    });
  }

  classifyImage(File image) async {

    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 127,
        imageStd: 255 ,
        numResults: 5,
        threshold: 0.3,
        asynch: true
        );
    setState(() {
      _loading = false;
      _outputs = output;
      for(int i = 0; i < _outputs.length; i++) {
        print(_outputs[i]);
        //print(_outputs[i]["label"]);
        //print(((_outputs[i]["confidence"])*100).toStringAsPrecision(4));
      }

    });
  }
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
  pickImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(_image);
    classifyImageAPI(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Preditor",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loading ? Container(
              height: 300,
              width: 300,
            ): 
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image == null ? Container() : Image.file(_image),
                  SizedBox(
                    height: 20,
                  ),
                  _image == null ? Container() : _outputs != null ?
                  Text("${_outputs[0]["label"]} - ${((_outputs[0]["confidence"])*100).toStringAsPrecision(4)} %" ,style: TextStyle(color: Colors.black,fontSize: 20),): Container(child: Text("")),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            FloatingActionButton(
              tooltip: 'Pick Image',
              onPressed: pickImage,
              child: Icon(Icons.add_a_photo,
              size: 20,
              color: Colors.white,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

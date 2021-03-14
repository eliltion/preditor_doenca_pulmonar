import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preditor_doenca_pulmonar/datas/paciente_data.dart';

class ImageData{

  String paciente;

  String id;
  String description;
  Timestamp data;

  String image;

  List pesos;
  List classes;

  PacienteData pac;

  ImageData();
  ImageData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    description = snapshot.data["description"];
    pesos = snapshot.data["pesos"];
    classes = snapshot.data["classes"];
    image = snapshot.data["image"];
    data = snapshot.data["data"];
  }

  Map<String, dynamic> todecriptionMap() {
    return{
      "description" : description,
    };
  }

  Map<String, dynamic> toMap() {
    return{
      "description" : description,
      "data" : data,
      "image" : image
    };
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageData{

  String paciente;

  String id;
  String description;
  Timestamp data;

  String image;

  List pesos;
  List classes;

  ImageData();
  ImageData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    description = snapshot.data["description"];
    pesos = snapshot.data["pesos"];
    classes = snapshot.data["classes"];
    image = snapshot.data["image"];
    data = snapshot.data["data"];
  }

  Map<String, dynamic> toMap() {
    return{
      "description" : description,
      "data" : data,
      "image" : image
    };
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preditor_doenca_pulmonar/datas/paciente_data.dart';

class CartProduct {

  String description;
  String image;
  Timestamp data;
  List pesos;
  List classes;

  PacienteData productData;

  CartProduct();

  //provavelmente será a documento (radio)
  CartProduct.from(DocumentSnapshot document){
    description = document.data["descrition"];
  }

  Map<String, dynamic> toMap(){
    return{
      "description" : description,
      "image" : image,
      "data" : data,
      "pesos" : pesos,
      "classes" : classes
    };
  }
}
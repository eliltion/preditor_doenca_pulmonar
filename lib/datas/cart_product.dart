
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

  //provavelmente será o documento (radio)
  CartProduct.from(DocumentSnapshot document){
    description = document.data["descrition"];
  }

  //realiza update da descrição e data de atualização da descrição da imagem
  Map<String, dynamic> todescriptionMap(){
    return{
      "description" : description,
      "data" : data
    };
  }

  //insere informações da imagem na tabela de radio.
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
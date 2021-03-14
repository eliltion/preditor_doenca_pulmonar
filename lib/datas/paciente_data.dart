import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

final String nomeColumn = "nomeColumn";
final String sexColumn = "sexColumn";
final String obsColumn = "obsColumn";
final String imgColumn = "imgColumn";
final String idColumn = "idColumn";

class PacienteData {

  String id;
  String nome;
  String observacao;


  PacienteData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    nome = snapshot.data["nome"];

    observacao = snapshot.data["observacao"];
  }

  Map<String, dynamic> toMap() {
    return{
      "nome" : nome,
      "observacao" : observacao
    };
  }

}
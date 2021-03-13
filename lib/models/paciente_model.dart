import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PacienteModel extends Model{


  FirebaseUser firebaseUser;
  Map<String, dynamic> pacienteData = Map();


  bool isLoading = false;

  void signUp({@required Map<String, dynamic> pacienteData,
    @required VoidCallback onSuccess, @required VoidCallback onFail}) async{

      await _savePacienteData(pacienteData);

      onSuccess();
      isLoading = false;
      notifyListeners();
  }

  Future<Null> _savePacienteData(Map<String, dynamic> pacienteData) async{
    this.pacienteData = pacienteData;
    await Firestore.instance.collection("paciente").document().setData(pacienteData);

  }



}

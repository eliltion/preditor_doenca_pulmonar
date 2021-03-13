

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/datas/cart_product.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;
  List<CartProduct> products = [];

  CartModel(this.user);

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  Future<void> addCartItem(CartProduct cartProduct, DocumentSnapshot snapshot, File image) async {
    //products.add(cartProduct);

    CartProduct ct = cartProduct;

    if(image != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child("image_lung").child(
        DateTime.now().microsecondsSinceEpoch.toString()
      ).putFile(image);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      ct.image = url;

    }
    Firestore.instance.collection("paciente").document(snapshot.documentID)
      .collection("radio").add(ct.toMap());

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){

   /* Firestore.instance.collection("user").document(user.firebaseUser.uid)
          .collection("cart").document(cartProduct.cid).delete();

    products.remove(cartProduct);*/

    notifyListeners();

  }
}
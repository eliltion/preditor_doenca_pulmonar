import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/tiles/paciente_tile.dart';

class PacienteTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("paciente").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var dividedTiles = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((doc) {
                    return PacienteTile(doc);
                  }).toList(),
                  color: Colors.white)
              .toList();
          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }

}

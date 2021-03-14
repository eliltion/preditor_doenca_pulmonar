import 'package:flutter/material.dart';
import 'package:preditor_doenca_pulmonar/screens/paciente_screen.dart';
import 'package:preditor_doenca_pulmonar/tabs/home_tab.dart';
import 'package:preditor_doenca_pulmonar/tabs/paciente_tab.dart';
import 'package:preditor_doenca_pulmonar/widgets/custom_drawer.dart';
import 'package:preditor_doenca_pulmonar/datas/paciente_data.dart';
import 'package:preditor_doenca_pulmonar/models/user_model.dart';


import '../main.dart';
//import 'paciente_screenss.dart';

enum OrderOptions {atualizar,ordenar}



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Pacientes"),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<OrderOptions>(
                itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Atualizar"),
                    value: OrderOptions.atualizar,
                  ),
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordernar"),
                    value: OrderOptions.ordenar,
                  ),
                ],
                onSelected: _orderAtualizar,
              )
            ],
          ),
          drawer: CustomDrawer(_pageController),
          body: PacienteTab(),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>PacienteScreen())
              );
            },
            child: Icon(Icons.person),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        Container(color:  Colors.red,),
        Container(color:  Colors.blue,),
      ],
    );
  }

void _orderAtualizar(OrderOptions result){

  setState(() {
    _pageController;
  });
}

}
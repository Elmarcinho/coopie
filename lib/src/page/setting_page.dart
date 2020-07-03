import 'package:flutter/material.dart';


class SettingPage extends StatelessWidget {
  
  // static final String routename = 'setting';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text('Ajuste')
      ),
      body: Center(
        child: Text('Ajustes Page')
      )
    );
  }
}
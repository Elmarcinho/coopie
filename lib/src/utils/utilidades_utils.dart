import 'package:flutter/material.dart';

import 'package:progress_dialog/progress_dialog.dart';


mostrarBienvenida(BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
          title: Text('Bienvenido(a)'),
          content:Text(mensaje)
      ); 
    }
  );
}

Future<void> mostrarMensaje(BuildContext context, String mensaje) async{

  await showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Mensaje'),
        content:Text(mensaje),
        actions: <Widget>[  
          FlatButton(
            child:  Text('Aceptar'),
            onPressed: (){
              Navigator.of(context).pop();
            }, 
            textColor: Colors.green,
          )
        ],
      );
    }
  );
}

crearLoading(ProgressDialog loading){
    loading.update(
      progress: 50.0,
      message: "Procesando....",
      progressWidget: Container(
        padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }

bool isNumero(String texto){

  if( texto.isEmpty) return false;

  final n = num.tryParse(texto);

  return (n==null) ? false : true;
}
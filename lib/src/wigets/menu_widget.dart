import 'package:flutter/material.dart';

import 'package:trufi_app/src/bloc/provider.dart';
import 'package:trufi_app/src/preferencia_usuario/preferencia_usuario.dart';
import 'package:trufi_app/src/utils/utilidades_utils.dart'as utils;
import 'package:trufi_app/src/utils/variable_utils.dart';



class MenuWidget extends StatefulWidget {
  
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}
class _MenuWidgetState extends State<MenuWidget> {

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {

    final loginbloc = Provider.of(context);

    return Drawer(
      child: ListView(  
        padding: EdgeInsets.zero, 
        children:<Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(  
              image: DecorationImage(
                image: AssetImage('assets/menu.jpg'),
                fit: BoxFit.cover
              )
            ),
            accountName: Text('${prefs.nombreUsuario.toString().toUpperCase()}'),
            accountEmail: Text('${prefs.email}'),
            currentAccountPicture: CircleAvatar(  
              backgroundColor: Colors.white,  
              child: Text('${prefs.nombreUsuario[0].toUpperCase()}',
              // child: Text('${prefs.nombreUsuario.toString().substring(0,1).toUpperCase()}',
                  style: TextStyle(fontSize:45.0, color: Theme.of(context).primaryColor)
              ),
            ),
          ),
          ListTile(
            leading:Icon(Icons.location_on , color:Colors.green),
            title: Text('Puntos de marcaje'),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, 'geovalla');
            }
          ),
          ListTile(
            leading:Icon(Icons.supervised_user_circle , color:Colors.green),
            title: Text('Asignar salida'),
            onTap: (){
              if(prefs.email=='control@coopiedades.com'){
                Navigator.pop(context);
                Navigator.pushNamed(context, 'listasalida');
              }
              else{
                utils.mostrarMensaje(context, 'Usted no tiene permiso para acceder a esta opcion');
              }
            }
          ),
          ListTile(
            leading:Icon(Icons.settings, color:Colors.green),
            title: Text('Ajustes'),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, 'ajuste');
            },
          ),
          ListTile(
            leading:Icon(Icons.power_settings_new, color:Colors.green),
            title: Text('Cerrar session'),
            onTap: (){
              subscription.cancel();
              loginbloc.resetStream();
              prefs.token='';
              Navigator.pushReplacementNamed(context, 'login');  
            },
          ),
        ]
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:trufi_app/src/bloc/provider.dart';
import 'package:trufi_app/src/preferencia_usuario/preferencia_usuario.dart';
import 'package:trufi_app/src/provider/usuario_provider.dart';
import 'package:trufi_app/src/utils/utilidades_utils.dart' as utils;


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final usuarioProvider= new UsuarioProvider();
  final prefs = new PreferenciasUsuario();
  bool _hidden = true;
  ProgressDialog loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _crearFormLogin(context),
        ],
      ) 
    );  
  }

  Widget _crearFormLogin(BuildContext context){
    
    final loginBloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    loading = new ProgressDialog(context,isDismissible: false);
    utils.crearLoading(loading);
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          
          SafeArea(
            child: Container(
              height: 140.0,  //posision de caja
            )
          ),    

          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical:40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                  Text('Iniciar sesión',style: TextStyle(fontSize:20.0)),
                  SizedBox(height: 30.0),
                  _crearEmail(loginBloc),
                  SizedBox(height: 30.0),
                  _crearPassword(loginBloc),
                  SizedBox(height: 30.0),
                  _crearBoton(context,loginBloc)
              ]
            ),
          ),
          FlatButton(
            child: Text('Crear nueva cuenta',
            style: TextStyle(color: Colors.white,
              decoration: TextDecoration.underline
            )),
            onPressed: ()=>Navigator.pushReplacementNamed(context, 'registrouser'),
          )
        ],
      ),
    );

  }

  Widget _crearEmail(LoginBloc loginbloc){

    return StreamBuilder(
      stream: loginbloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal:20.0),

          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
            icon: Icon(Icons.alternate_email, color: Colors.green,),
            hintText: 'Ejemplo@correo.com',
            labelText: 'Correo electrónico',
            errorText: snapshot.error
            ),
            onChanged: loginbloc.changeEmail,
          )
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc loginbloc){   

    return StreamBuilder(
      stream: loginbloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal:20.0),

          child: TextField(
            obscureText: _hidden,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.green),
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                icon: Icon(Icons.visibility_off), 
                onPressed: (){ setState(()=>_hidden?_hidden=false:_hidden=true); }
              ),
              errorText: snapshot.error 
            ),
            onChanged: loginbloc.changePassword,
          )
        );
      },
    );
  }

  Widget _crearBoton(BuildContext context,LoginBloc loginbloc){

    return StreamBuilder(
      stream: loginbloc.loginValidStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical:15.0),
            child:Text('Ingresar')
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)  
          ),
          elevation: 0.0,
          color: Colors.green,
          textColor: Colors.white,  
          onPressed: snapshot.hasData? () => _login(context,loginbloc) : null,
        );
      },
    );
  }

  _login(BuildContext context,LoginBloc loginbloc, ) async {
   
   await loading.show();
    Map info = await usuarioProvider.login(loginbloc.email, loginbloc.password);

    if(info['ok']){

      var nombre = await usuarioProvider.getListaChoferCloud(loginbloc.email);

      if(nombre.exists){
        await loading.hide();
        await utils.mostrarBienvenida(context, '${prefs.nombreUsuario.toString().toUpperCase()}');
        Timer(Duration(milliseconds: 1200), (){
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, 'home');  
        });
      }
      else{
        await loading.hide();
        await utils.mostrarMensaje(context,'Error, ingrese nuevamente los datos');
      }

    }
    else{
      await loading.hide();
      await utils.mostrarMensaje(context,info['mensaje']);
    }

  }

  Widget _crearFondo(BuildContext context){

    final size = MediaQuery.of(context).size;
    
    final fondoVerde = Container(
      height: size.height * 1.0,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient:LinearGradient(
          colors:<Color>[
            Colors.green,
            Colors.green,
          ]
        )
      ),
    );

    return Stack(
      children: <Widget>[
        fondoVerde,
        Container(
          padding: EdgeInsets.only(top: 10.0 ),
          child: Column(
            children:<Widget>[
              Icon(Icons.directions_car, color: Colors.white, size: 100),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('Cooperativa Las Piedades', style: TextStyle(color:Colors.white, fontSize:25.0))
            ]
          )
        )     
      ],
    );
  }
}
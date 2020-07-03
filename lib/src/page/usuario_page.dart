import 'package:flutter/material.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:trufi_app/src/bloc/provider.dart';

import 'package:trufi_app/src/bloc/usuario_bloc.dart';
import 'package:trufi_app/src/provider/usuario_provider.dart';
import 'package:trufi_app/src/utils/utilidades_utils.dart' as utils;


class RegistroUserPage extends StatefulWidget {

  @override
  _RegistroUserPageState createState() => _RegistroUserPageState();
}

class _RegistroUserPageState extends State<RegistroUserPage> {

  final usuarioProvider= new UsuarioProvider();

  ProgressDialog loading;
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      appBar: AppBar(
        centerTitle: true,
        title:Text('Registro de Usuario')
      ),
      body: _crearFormLogin(context)
    );  
  }

  Widget _crearFormLogin(BuildContext context){

    final usuarioBloc = Provider.usuarioBloc(context);
    loading = new ProgressDialog(context,isDismissible: false);
    utils.crearLoading(loading);
    
    return SingleChildScrollView(
      child:Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          child:Column(
            children:<Widget>[
              _crearNombre( usuarioBloc),
              _crearCedulaIdentidad(usuarioBloc),
              _crearEmail(usuarioBloc),
              _crearPassword(usuarioBloc),
              SizedBox(height: 50),
              _crearBotonGuardar(context,usuarioBloc),
              SizedBox(height: 70),
              _crearBotonAtras(context)
            ]
          ),
        ),
      ),
    );
  }

  Widget _crearNombre(UsuarioBloc usuarioBloc){

    return StreamBuilder(
      stream: usuarioBloc.nombreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal:20.0),

          child: TextField(
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
            icon: Icon(Icons.person_outline, color: Colors.green),
            hintText: 'Ingrese nombre y apellido',
            labelText: 'Nombre y Apellido',
            errorText: snapshot.error,
            ),
            onChanged: usuarioBloc.changeNombre,
          )
        );
      },
    );
  }

  Widget _crearCedulaIdentidad(UsuarioBloc usuarioBloc){

    return StreamBuilder(
      stream: usuarioBloc.cedulaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal:20.0),

          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
            icon: Icon(Icons.border_color, color: Colors.green),
            hintText: 'Ingrese cedula de identidad',
            labelText: 'Cedula de identidad',
            errorText: snapshot.error
            ),
            onChanged: usuarioBloc.changeCedula,
          )
        );
      },
    );
  }

  Widget _crearEmail(UsuarioBloc usuarioBloc){

    return StreamBuilder(
      stream: usuarioBloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal:20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
            icon: Icon(Icons.alternate_email, color: Colors.green),
            hintText: 'Ejemplo@correo.com',
            labelText: 'Correo electrónico',
            errorText: snapshot.error
            ),
            onChanged: usuarioBloc.changeEmail,
          )
        );
      },
    );
  }

  Widget _crearPassword(UsuarioBloc usuarioBloc){   

    return StreamBuilder(
      stream: usuarioBloc.passwordStream,
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
            onChanged: usuarioBloc.changePassword,
          )
        );
      },
    );
  }

  Widget _crearBotonGuardar(BuildContext context, UsuarioBloc usuarioBloc){

    return StreamBuilder(
      stream: usuarioBloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical:15.0),
            child:Text('Registrar')
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.green,
          textColor: Colors.white,
          onPressed: snapshot.hasData? () =>_registrarUser(context, usuarioBloc) : null,
        );
      },
    );
  }

  Widget _crearBotonAtras(BuildContext context){

     return FlatButton(
      child: Text('¿Ya tienes una cuenta?, Ingresar',
      style: TextStyle(fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline
      )),
      onPressed: ()=>Navigator.pushReplacementNamed(context, 'login'),
    );
  }      


  void _registrarUser(BuildContext context, UsuarioBloc usuarioBloc) async {
   
   await loading.show(); 
   final info = await usuarioProvider.registrarUsuario(usuarioBloc.email, usuarioBloc.password);

   if(info['ok']){
      
      await usuarioProvider.insertarUsuarioCloud(usuarioBloc.email,usuarioBloc.nombre, int.parse(usuarioBloc.cedula));
      await loading.hide();
      await utils.mostrarMensaje(context,'Usuario registrado con exito!');
      Navigator.pushReplacementNamed(context, 'login');  
    } 
    else{
      await loading.hide();
      await utils.mostrarMensaje(context,info['mensaje']);
    }

  }
}
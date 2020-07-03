import 'package:flutter/cupertino.dart';

import 'package:trufi_app/src/bloc/login_bloc.dart';
export 'package:trufi_app/src/bloc/login_bloc.dart';
import 'package:trufi_app/src/bloc/usuario_bloc.dart';
export 'package:trufi_app/src/bloc/usuario_bloc.dart';
import 'package:trufi_app/src/bloc/salida_bloc.dart';
export 'package:trufi_app/src/bloc/salida_bloc.dart';
import 'package:trufi_app/src/bloc/marcaje_bloc.dart';
export 'package:trufi_app/src/bloc/marcaje_bloc.dart';



class Provider extends InheritedWidget{

  final longinBloc = new LoginBloc();
  final _usuarioBloc = new UsuarioBloc();
  final _salidaBloc = new SalidaBloc();
  final _marcajeBloc = new MarcajeBloc();
 
  static Provider _instancia;

  factory Provider({Key key, Widget child}){

    if(_instancia==null){

      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child})
  : super(key:key , child:child);
  

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>true;

  static LoginBloc of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().longinBloc;
  }

  static UsuarioBloc usuarioBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._usuarioBloc;
  }

  static SalidaBloc salidaBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._salidaBloc;
  }

  static MarcajeBloc marcajeBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._marcajeBloc;
  }

}
import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:trufi_app/src/bloc/validator.dart';


class UsuarioBloc with Validator{


  final _nombreController = new BehaviorSubject<String>();
  final _cedulaController = new BehaviorSubject<String>();
  final _emailController = new BehaviorSubject<String>();
  final _passwordController = new BehaviorSubject<String>();


  //recuperar los datos del stream
  Stream<String> get nombreStream    => _nombreController.stream.transform(validarNombre);
  Stream<String> get cedulaStream    => _cedulaController.stream.transform(validarCedula);
  Stream<String> get emailStream    => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);  

  Stream<bool> get formValidStream =>
    CombineLatestStream.combine4(nombreStream, cedulaStream, emailStream, passwordStream, (n, c, e, p,) => true);


  //insertar valores al stream
  Function(String) get changeNombre   => _nombreController.sink.add;
  Function(String) get changeCedula   => _cedulaController.sink.add;
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;  

  //Obtener el ultimo valor ingresado a los stream
  String get nombre  => _nombreController.value;
  String get cedula  => _cedulaController.value;
  String get email   => _emailController.value;
  String get password => _passwordController.value;


  dispose(){  
    _nombreController?.close();
    _cedulaController?.close();
    _emailController?.close();
    _passwordController.close();

  }


}
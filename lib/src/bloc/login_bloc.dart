import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:trufi_app/src/bloc/validator.dart';


class LoginBloc with Validator{

  final _emailController = new BehaviorSubject<String>();
  final _passwordController = new BehaviorSubject<String>();

  //recuperar los datos del stream
  Stream<String> get emailStream    => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);  

  Stream<bool> get loginValidStream =>
    CombineLatestStream.combine2(emailStream, passwordStream, (e, p,) => true);

  //insertar valores al stream
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;  

  //Obtener el ultimo valor ingresado a los stream
  String get email  => _emailController.value;
  String get password => _passwordController.value;


   void resetStream() {
    // _emailController.value = '';
    _passwordController.value = '';
  }

  void dispose(){  
    _emailController?.close();
    _passwordController?.close(); 
  }


}
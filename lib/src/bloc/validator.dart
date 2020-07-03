import 'dart:async';


class Validator{


  final validarNombre = StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){

      if(nombre != null && nombre != '' && nombre != ' '){
        sink.add(nombre);
      }
      else{
        sink.addError('Ingrese nombre y apellido');
      }
      
    }
  );

  final validarCedula = StreamTransformer<String,String>.fromHandlers(
    handleData: (cedula,sink){
      
      final n = num.tryParse(cedula);
      if(n != null && cedula.length > 6){
        sink.add(cedula);
      }
      else{
        sink.addError('Ingrese solo numeros');
      }
      
    }
  );

  final validarEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: ( email, sink ){

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp =   new RegExp(pattern);
      
      if(regExp.hasMatch(email)){
        sink.add(email);
      }
      else{
        sink.addError('Email no es válido');
      }
    }
  );

    //Podriamos transformar el string a entero si fuera el caso
  final validarPassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){

      if(password.length >= 6 ){
        sink.add(password);
      }
      else{
        sink.addError('Más de 6 caracteres por favor');
      }
      
    }
  );

}
import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:trufi_app/src/model/salida_model.dart';
import 'package:trufi_app/src/provider/salida_provider.dart';



class SalidaBloc {

  final _salidaController = new BehaviorSubject<List<SalidaModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _salidaProvider = new SalidaProvider();
  
  //recuperar los datos del stream
  Stream<List<SalidaModel>> get salidaStream => _salidaController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;


  void traerSalida() async{

    final salida =  await _salidaProvider.traerSalida();
    _salidaController.sink.add(salida);
  }

  Future<bool> insertarSalida(SalidaModel salida) async{
    bool estado=true;
    _cargandoController.sink.add(true);
    await _salidaProvider.insertarSalida(salida).then((value) => estado=value);
    _cargandoController.sink.add(false);
    traerSalida();
    
    return estado ;
  }

  Future<bool> actualizarSalida(SalidaModel salida) async{
    bool estado=true;
    _cargandoController.sink.add(true);
    await _salidaProvider.actualizarSalida(salida).then((value) => estado=value);
    _cargandoController.sink.add(false);
    traerSalida();
    
    return estado;
  }


  void dispose(){  
    _salidaController?.close(); 
    _cargandoController?.close(); 
  }


}
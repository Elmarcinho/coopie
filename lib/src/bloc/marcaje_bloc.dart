import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:trufi_app/src/model/marcaje_model.dart';
import 'package:trufi_app/src/provider/marcaje_provider.dart';




class MarcajeBloc {

  final _marcajeController = new BehaviorSubject<List<MarcajeModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _marcajeProvider = new MarcajeProvider();
  
  //recuperar los datos del stream
  Stream<List<MarcajeModel>> get marcajeStream => _marcajeController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;


  void traerMarcaje(int cedula) async{

    final marcaje =  await _marcajeProvider.traerMarcaje(cedula);
    _marcajeController.sink.add(marcaje);
  }

  Future<bool> insertarMarcaje(MarcajeModel marcaje) async{
    bool estado=true;
    _cargandoController.sink.add(true);
    await _marcajeProvider.insertarMarcaje(marcaje).then((value) => estado=value);
    _cargandoController.sink.add(false);
    traerMarcaje(marcaje.cedula);
    
    return estado ;
  }


  void dispose(){  
    _marcajeController?.close(); 
    _cargandoController?.close(); 
  }


}
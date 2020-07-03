import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:trufi_app/src/model/marcaje_model.dart';
import 'package:trufi_app/src/provider/salida_provider.dart';



class MarcajeProvider {


  final _dbTrufi = Firestore.instance;
  final salidaProvider = new SalidaProvider();
  bool estado = true;

  Future<bool> insertarMarcaje(MarcajeModel marcaje) async { 
  
    return await _dbTrufi
      .collection('marcaje')
      .document()
      .setData({
        'atraso'          : marcaje.atraso,
        'cedula'          : marcaje.cedula,
        'chofer'          : marcaje.chofer,
        'fecha'           : marcaje.fecha,
        'fechaHoraSalida' : marcaje.fechaHoraSalida,
        'fechaHoraMarcaje': Timestamp.fromDate(DateTime.parse(marcaje.fechaHoraMarcaje)),
        'fechaHoraLlegada' : marcaje.fechaHoraLlegada,
        'geo'             : marcaje.geo,
        'movil'           : marcaje.movil,
        'puntoMarcaje'    : marcaje.puntoMarcaje,
        'timestamp'       : FieldValue.serverTimestamp()
    }).then((value) => value=true); 

  }

  
  Future<List<MarcajeModel>> traerMarcaje(int cedula) async{

    var salida= await salidaProvider.traerSalidaChoferEstado(cedula, estado);
    
    if(salida.length > 0 ){

      String fechaHoraSalida;
      salida.forEach((element) {
        fechaHoraSalida=element.fechaHoraSalida;
      });

      return await _dbTrufi.collection('marcaje')
      .where('cedula',isEqualTo:cedula)
      .where('fechaHoraSalida',isEqualTo:fechaHoraSalida)
      .orderBy('fechaHoraMarcaje', descending: true)
      .getDocuments()
      .then((value) => value.documents.map((e) => MarcajeModel.fromJson(e.data)).toList());
    }
    else{ return []; }
    
  }
 
  // Stream<QuerySnapshot> traerListaMarcajeCloud(){

  //   return _dbTrufi
  //    .collection('marcaje')
  //    .snapshots();
  // }

}
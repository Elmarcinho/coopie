import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trufi_app/src/model/detalleSalida_model.dart';

import 'package:trufi_app/src/model/salida_model.dart';

  
  // TODO: controlar error de las funciones

class SalidaProvider{

  final _dbTrufi= Firestore.instance;


  Future<bool> insertarSalida(SalidaModel salida) async { 
    
    var a = await traerSalidaChoferEstado(salida.cedulaChofer,salida.estado);
      
      if(a.length == 0){

        return await _dbTrufi.collection('salida')
        .document(salida.id).setData(salida.toJson()).then((value) => value=true); 
      }

     return false;
  }


  Future<List<SalidaModel>> traerSalidaChoferEstado(int cedula, bool estado) async{

     return await _dbTrufi.collection('salida')
      .where('cedulaChofer',isEqualTo:cedula)
      .where('estado',isEqualTo:estado)
      .getDocuments()
      .then((value) => value.documents
      .map((e) => SalidaModel
      .fromJson(e.data)).toList());

  }
  

  Future<bool> actualizarSalida(SalidaModel chofer) async { 
    
    return await _dbTrufi.collection('salida')
    .document(chofer.id).updateData(chofer.toJson()).then((value) => value=true);
     
  }

  Future<bool> actualizarSalidaEstado(String id, bool estado) async { 
    
    return await _dbTrufi.collection('salida')
    .document(id).updateData({'estado':estado}).then((value) => value=true);
     
  }


  Future<List<DetalleSalidaModel>> detalleSalida(int cedula, bool estado)async{

    List<DetalleSalidaModel> listadetalleSalida = new List();

    if(cedula==0) return [];

    var salida = await traerSalidaChoferEstado(cedula, estado);
    if(salida.length > 0 ){

      QuerySnapshot geo = await _dbTrufi.collection('geovalla').getDocuments(); 

      if(geo.documents.length > 0 ){
        salida.forEach((x) {
          DateTime fechaSalida =  DateTime.parse(x.fechaHoraSalida);
          geo.documents.forEach((y) { 
            
            final detalleModel = new DetalleSalidaModel();
            DateTime tiempoGeoValla =  DateTime.parse(y.data['minuto'].toString());
            DateTime horaPronostico= fechaSalida.add(Duration(hours:tiempoGeoValla.hour,minutes: tiempoGeoValla.minute));

            detalleModel.id   = x.id;
            detalleModel.cedulaChofer = x.cedulaChofer;
            detalleModel.nombreGeoPunto = y.data['nombre'];
            detalleModel.fechaHoraSalida = x.fechaHoraSalida;
            detalleModel.fechaHoraLlegada = horaPronostico.toString();
            detalleModel.movil = x.movil;

            listadetalleSalida.add(detalleModel);
          });
        });
      }
    }
    else{ return []; }

    return listadetalleSalida;
  }

  // Stream<List<SalidaModel>> traerSalidaChofer() {

  //   return _dbTrufi.collection('salida').snapshots()
  //   .map((event) => event.documents
  //   .map((e) => SalidaModel.fromJson(e.data)).toList());
  
  // }

  // Stream<List<DetalleSalidaModel>> detalleSalida2(int cedula, bool estado){

  //   List<DetalleSalidaModel> detalleSalida = new List();

  //   if(cedula==0) return [];

  //   Stream<List<SalidaModel>> salida = _dbTrufi.collection('salida')
  //   .where('cedulaChofer',isEqualTo:cedula)
  //   .where('estado',isEqualTo:estado)
  //   .snapshots()
  //   .map((event) => event.documents
  //   .map((e) => SalidaModel.fromJson(e.data)));

  //   salida.toList().then((value){
  //     if(value.length > 0 ){
  //       Stream<List<SalidaModel> geo >
  //     }
  //   });



  //   if(salida.length>0){

  //     QuerySnapshot geo =  _dbTrufi.collection('geovalla').getDocuments(); 

  //     if(geo.documents.length>0){
  //       salida.forEach((x) {
  //         DateTime fechaSalida =  DateTime.parse(x.fechaHoraSalida);
  //         geo.documents.forEach((y) { 
            
  //           final pronostico = new DetalleSalidaModel();
  //           DateTime tiempoGeoValla =  DateTime.parse(y.data['minuto'].toString());
  //           DateTime horaPronostico= fechaSalida.add(Duration(hours:tiempoGeoValla.hour,minutes: tiempoGeoValla.minute));

  //           pronostico.cedulaChofer = x.cedulaChofer;
  //           pronostico.nombreGeoPunto = y.data['nombre'];
  //           pronostico.fechaHoraSalida = x.fechaHoraSalida;
  //           pronostico.fechaHoraPronostico = horaPronostico.toString();
  //           listapronostico.add(pronostico);
  //         });
  //       });
  //     }
  //   }
  //   else{ return []; }

  //   return detalleSalida;
  // }


  // Stream<QuerySnapshot> getTraerAsignadoSalida() {

  //    return _dbTrufi.collection('salida')
  //     .snapshots();
  // }

  Future<List<SalidaModel>> traerSalida() async{

    return await _dbTrufi.collection('salida')
      .getDocuments()
      .then((value) => value.documents
      .map((e) => SalidaModel
      .fromJson(e.data)).toList());
  }

  //  Future<bool> insertarSalida(SalidaModel salida) async { 
    
  //     await _dbTrufi
  //     .collection('salida')
  //     .document()
  //     .setData({
  //       'cedulaChofer' : salida.cedulaChofer,
  //       'nombreChofer' : salida.nombreChofer.toLowerCase(),
  //       'estado' : 'activo',
  //       'fechaHoraSalida' : salida.fechaHoraSalida,
  //       'movil'  : salida.movil
  //     });
  // }
}
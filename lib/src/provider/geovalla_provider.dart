import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:trufi_app/src/model/geovalla_model.dart';



class GeoVallaProvider {

  final _dbTrufi= Firestore.instance;

  Future<List<GeoVallaModel>> traerListaGeoValla(){
  
    return _dbTrufi
    .collection('geovalla')
    .getDocuments()
    .then((value) => value.documents
    .map((e) => GeoVallaModel.fromJson(e.data)).toList());
  }


  Future<List<GeoVallaModel>> getListaGeoValla(String geovalla)async{

   return await _dbTrufi.collection('geovalla')
    .where('nombre',isEqualTo:geovalla)
    .getDocuments().then((value) => value.documents
    .map((e) => GeoVallaModel.fromJson(e.data)).toList()); 

  }

  // Future<QuerySnapshot> getListaGeoValla()async{

  //  return await _dbTrufi.collection('geovalla')
  //   .getDocuments(); 

  // }

  // Future<QuerySnapshot> getListaGeoVallaCloud(String geovalla)async{

  //  return await _dbTrufi.collection('geovalla')
  //   .where('nombre',isEqualTo:geovalla)
  //   .getDocuments(); 

  // }
  
  // Stream<List<GeoVallaModel>> traerListaGeoValla(){
  
  //   return _dbTrufi
  //   .collection('geovalla')
  //   .snapshots()
  //   .map((event) => event.documents
  //   .map((e) => GeoVallaModel.fromJson(e.data)).toList());
  // }

 

}
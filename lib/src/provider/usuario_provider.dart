import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:trufi_app/src/model/usuario_model.dart';
import 'package:trufi_app/src/preferencia_usuario/preferencia_usuario.dart';


class UsuarioProvider{

  final String _firebaseToken  = 'AIzaSyByyEjjoNnLc4cdsxYpqyY5an_elKSYxWk';
  final _preferencia = PreferenciasUsuario();
  final _dbTrufi= Firestore.instance;


  Future<Map<String,dynamic>> login(String email, String password)async{

    final authData= {
        'email'   : email.toLowerCase(),
        'password': password,
        'returnSecureToken': true
      };
      
      final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData) 
      );
      
      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if(decodeResp.containsKey('idToken')){
        
        _preferencia.token = decodeResp['idToken'];
        _preferencia.email = decodeResp['email'];

        return{'ok':true, 'token':decodeResp['idToken']};
      }
      else{
        return {'ok':false, 'mensaje':decodeResp['error']['message']};
      }

  }

  Future<DocumentSnapshot> getListaChoferCloud(String email) async{

   DocumentSnapshot chofer = await _dbTrufi.collection('usuario').document(email.toLowerCase()).get();
  
    if(chofer.exists){
      _preferencia.nombreUsuario= chofer.data['nombreUsuario'];
      _preferencia.cedula= chofer.data['cedula'];
    }

    return chofer;

  }


  Future<Map<String,dynamic>> registrarUsuario(String email, String password) async{

      final authData= {
        'email'   : email,
        'password': password,
        'returnSecureToken': true
      };
      
      final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData) 
      );

      Map<String, dynamic> decodeResp = await json.decode(resp.body);

      if(decodeResp.containsKey('idToken')){

        _preferencia.token = decodeResp['idToken'];

        return{'ok':true, 'token':decodeResp['idToken']};
      }
      else{
        return {'ok':false, 'mensaje':decodeResp['error']['message']};
      }

  }
  Future<void> insertarUsuarioCloud(String email, String nombre , int cedula ) async { 
  
      await _dbTrufi
      .collection('usuario')
      .document(email.toLowerCase())
      .setData({
        'nombreUsuario' : nombre.toLowerCase(),
        'cedula'       : cedula
      });
  }

  Future<List<UsuarioModel>> getbuscarUsuario(String nombreUsuario) async{

    final List<UsuarioModel> usuario = new List();

    var query =  await _dbTrufi.collection('usuario') 
      .where('nombreUsuario', isGreaterThanOrEqualTo:nombreUsuario) 
      .where('nombreUsuario', isLessThanOrEqualTo:nombreUsuario+'z')  
      .getDocuments();

      query.documents.forEach((id) {

        final usuarioTemp= UsuarioModel.fromJson(id.data);
        usuario.add(usuarioTemp);
       
      });

    return usuario;
  }
  
}
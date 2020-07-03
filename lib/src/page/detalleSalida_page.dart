import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:trufi_app/src/model/detalleSalida_model.dart';
import 'package:trufi_app/src/preferencia_usuario/preferencia_usuario.dart';
import 'package:trufi_app/src/provider/geovalla_provider.dart';
import 'package:trufi_app/src/provider/salida_provider.dart';



class SalidaPage extends StatelessWidget {
  
  final geoVallaProvider = new GeoVallaProvider();
  final salidaProvider = new SalidaProvider();
  final prefs = new PreferenciasUsuario();
  final DateFormat hourFormat = new DateFormat('HH:mm:ss');
  final DateFormat dateFormat = new DateFormat('dd-MM-yyyy');
  final bool estado=true; 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(30.0),
      //   child: AppBar(
      //     title:Text('Salida',style: TextStyle(color: Colors.black),),
      //     centerTitle: true,
      //     backgroundColor: Colors.white,
      //   ),
      // ),
      body: _crearDetalleSalida()
    );
  }
 
  Widget _crearDetalleSalida(){
    
    return FutureBuilder<List<DetalleSalidaModel>>(
      future: salidaProvider.detalleSalida(prefs.cedula, estado),
      builder: (BuildContext context, AsyncSnapshot<List<DetalleSalidaModel>> snapshot){

        if(!snapshot.hasData){return Center (child: CircularProgressIndicator());}
        if(snapshot.data.length == 0){return Center (child: Text('No existe salida activa para mostrar.'));}
        
        return Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 65,
              padding: const EdgeInsets.fromLTRB(0,20,0,10),
              alignment: Alignment.topCenter,
              child: Text(
                'Salida: ${hourFormat.format(DateTime.parse(snapshot.data[0].fechaHoraSalida))}',
                style: TextStyle(color: Colors.white, fontSize:20)
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: ( context, j) => Divider(
                height: 1,
                thickness: 1.0,
                color: Colors.green,
              ),
                itemBuilder: (contex, i){
                  String punto = '${snapshot.data[i].nombreGeoPunto.toUpperCase()}';
                  String hora ='Llegada: ${hourFormat.format(DateTime.parse(snapshot.data[i].fechaHoraLlegada))}';
                  return ListTile(
                    title: Text(punto, style: TextStyle(fontSize:17)),
                    subtitle: Text(hora, style:TextStyle(fontSize:18, color: Colors.black)),
                    leading: Icon(Icons.timer),
                    onLongPress: (){}
                  );
                },  
              )
            ),
          ],
        );
      }
    );
  }
}
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:trufi_app/src/model/geovalla_model.dart';

import 'package:trufi_app/src/provider/geovalla_provider.dart';



class GeoVallaPage extends StatelessWidget {

  final geoProvider= new GeoVallaProvider();
  final DateFormat hourFormat = new DateFormat('HH:mm:ss');


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text('Geovalla')
      ),
      body: _crearListadoGeoValla(),
    );
  }

  Widget _crearListadoGeoValla(){
    
    return FutureBuilder<List<GeoVallaModel>>(
      future: geoProvider.traerListaGeoValla(),
      builder:  (BuildContext context, AsyncSnapshot<List<GeoVallaModel>> snapshot){
        
        if(!snapshot.hasData){return Center (child: CircularProgressIndicator());}
        
        return ListView.separated(
          itemCount: snapshot.data.length,
          separatorBuilder: ( context, j) => Divider(
            height: 5.0,
            thickness: 1.0,
            color: Colors.green,
          ),
          itemBuilder: (contex, i){
            String titulo = '${snapshot.data[i].nombre.toUpperCase()}\n'
            'Tiempo: ${hourFormat.format(DateTime.parse(snapshot.data[i].minuto))}';
            String subtitulo = 'Geo: ${snapshot.data[i].geo} - '
                          'radio:${snapshot.data[i].radio.toString()}';
            return ListTile(
              title: Text(titulo, style: TextStyle(fontSize:17)),
              subtitle: Text(subtitulo, style: TextStyle(fontSize:15)),
              leading: Icon(Icons.location_on),
              onLongPress: () {}
            );
          },  
        );
      }
    );
  }

  // Widget _crearItem(GeoVallaModel geoValla){

  //   return Dismissible(
  //     key: UniqueKey(),
  //     background: Container(color: Colors.red), 
  //     child: ListTile(    
  //     title: Text('${geoValla.nombre} - ${geoValla.lat} - ${geoValla.lng}'),
  //     subtitle: Text('Geo: ${geoValla.id} - ${geoValla.radio}- ${geoValla.minuto}'),
  //     )
  //   );

  // }

}
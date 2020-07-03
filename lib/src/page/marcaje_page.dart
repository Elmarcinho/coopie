import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:trufi_app/src/bloc/provider.dart';
import 'package:trufi_app/src/model/marcaje_model.dart';
import 'package:trufi_app/src/preferencia_usuario/preferencia_usuario.dart';


class MarcajePage extends StatelessWidget {

    final DateFormat hourFormat = new DateFormat('HH:mm:ss');
    final DateFormat dateFormat = new DateFormat('dd-MM-yyyy');
    final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {

    final marcajeBloc = Provider.marcajeBloc(context);
    marcajeBloc.traerMarcaje(prefs.cedula);

    return _crearListaMarcaje(marcajeBloc);
  }


  Widget _crearListaMarcaje(MarcajeBloc marcajeBloc){
    
    return StreamBuilder<List<MarcajeModel>>(
      stream: marcajeBloc.marcajeStream,
      builder: (BuildContext context, AsyncSnapshot<List<MarcajeModel>> snapshot){

        if(!snapshot.hasData){return Center (child: CircularProgressIndicator());}
        if(snapshot.data.length == 0){return Center (child: Text('No existe marcaje para mostrar.'));}
        
        return Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 65,
              padding: const EdgeInsets.fromLTRB(0,20,0,10),
              alignment: Alignment.topCenter,
              child: Text(
                'Marcaje - Movil: ${snapshot.data[0].movil}',
                style: TextStyle(color: Colors.white, fontSize:20)
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: ( context, j) => Divider(
                  height: 5.0,
                  thickness: 1.0,
                  color: Colors.green,
                ),
                itemBuilder: (contex, i){
                  String titulo = snapshot.data[i].puntoMarcaje.toUpperCase() +'\n'
                                  'Marcaje: '+ hourFormat.format(DateTime.parse(snapshot.data[i].fechaHoraMarcaje))+'      '
                                  'Atraso: '+snapshot.data[i].atraso.toString();
                  String subtitulo ='Salida: '+hourFormat.format(DateTime.parse(snapshot.data[i].fechaHoraSalida))+'   '
                                    'Llegada: '+ hourFormat.format(DateTime.parse(snapshot.data[i].fechaHoraLlegada));
                  return ListTile(    
                    title: Text(titulo, style:TextStyle(fontSize:17)),
                    subtitle: Text(subtitulo, style:TextStyle(fontSize:15)),
                    leading: Icon(Icons.access_time),
                    onTap: (){},
                  );
                },  
              ),
            ),
          ],
        );
      }
    );
  }

  // Widget _crearItem(MarcajeModel geo){

  //   return Dismissible(
  //     key: UniqueKey(),
  //     background: Container(color: Colors.red), 
  //     child: ListTile(    
  //     title: Text('${geo.movil} / ${geo.chofer} - ${geo.fecha} - ${geo.horaMarcaje}'),
  //     subtitle: Text('Geo: ${geo.lat} / ${geo.lng}'),
  //     )
  //   );

  // }


}
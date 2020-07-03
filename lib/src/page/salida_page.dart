import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:trufi_app/src/model/salida_model.dart';
import 'package:trufi_app/src/search/search_delegate.dart';
import 'package:trufi_app/src/bloc/provider.dart';


class SalidaPage extends StatelessWidget {
  
  final DateFormat hourFormat = new DateFormat('HH:mm:ss');
  final DateFormat dateFormat = new DateFormat('dd-MM-yyyy');
 
  @override
  Widget build(BuildContext context) {

    final salidaBloc = Provider.salidaBloc(context);
    salidaBloc.traerSalida();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text('Lista de salida'),
        // actions: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.add_circle_outline),
        //       onPressed: (){},
        //     )
        //   ],
      ),
      body: _crearListaSalidas(salidaBloc),
      floatingActionButton: _crearBotonFlotante(context)
    );
  }

  Widget _crearBotonFlotante(BuildContext context){
    
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
      onPressed:() => showSearch(context: context, delegate: DataSearch())
    );
  }

  Widget _crearListaSalidas(SalidaBloc salidaBloc){
    
    return StreamBuilder<List<SalidaModel>>(
      stream: salidaBloc.salidaStream,
      builder: (BuildContext context, AsyncSnapshot<List<SalidaModel>> snapshot){

        if(!snapshot.hasData){return Center (child: CircularProgressIndicator());}
        
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (contex, i){
            String estado;
            snapshot.data[i].estado?estado='Activo':estado='Inactivo';
            String titulo = 'Movil: '+snapshot.data[i].movil.toString()+' | '
                             +snapshot.data[i].nombreChofer.toUpperCase()+' | '
                             'Fecha:'+dateFormat.format(DateTime.parse(snapshot.data[i].fechaHoraSalida));
            String subtitulo = 'Salida: '+hourFormat.format(DateTime.parse(snapshot.data[i].fechaHoraSalida))+ ' | '
                              'Estado: '+estado;
            return ListTile(    
              title: Text('$titulo'),
              subtitle: Text('$subtitulo'),
              onTap: () => Navigator.pushNamed(context, 'actualizarsalida',arguments: snapshot.data[i])  
            );
          },  
        );
      }
    );
  }
}
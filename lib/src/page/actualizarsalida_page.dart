import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:trufi_app/src/model/salida_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:trufi_app/src/bloc/provider.dart';
import 'package:trufi_app/src/utils/utilidades_utils.dart' as utils;



class ActualizarAsignarSalida extends StatefulWidget {
  
  @override
  _ActualizarAsignarSalidaState createState() => _ActualizarAsignarSalidaState();
}

class _ActualizarAsignarSalidaState extends State<ActualizarAsignarSalida> {

  SalidaBloc salidaBloc;
  SalidaModel salidaChofer = new SalidaModel();
  final formKey = GlobalKey<FormState>();
  final DateFormat hourFormat = new DateFormat('HH:mm:ss');
  final myController = TextEditingController();
  String fecha=DateFormat('yyyy-MM-dd ').format(DateTime.now());  
  ProgressDialog loading;  
  String time;

  _timeValue() {
    if(time==null){
     myController.text= hourFormat.format(DateTime.parse( salidaChofer.fechaHoraSalida));
    }
    else{
      myController.text=hourFormat.format(DateTime.parse(time));
    }   
  }
  
  @override 
  Widget build(BuildContext context) {
    
    salidaBloc = Provider.salidaBloc(context);
    final SalidaModel salidaData = ModalRoute.of(context).settings.arguments;
    salidaChofer = salidaData;
    loading = new ProgressDialog(context,isDismissible: false);
    utils.crearLoading(loading);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text('Actualizar salida'),
      ),  
      body: _crearFormAsignarSalida(context)
    );
  }

   Widget _crearFormAsignarSalida(BuildContext context){
   
    return SingleChildScrollView(
      child:Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child:Column(
            children:<Widget>[
             _crearNombre(),
             _crearCedula(),
            Row(
              children:<Widget>[
                _crearHora(),
                _crearBotonHora()
              ]
            ),
            _crearMovil(),
            SizedBox(height: 15),
            _crearEstado(),
            SizedBox(height: 50),
            _crearBotonGuardar(context)
            ]
          ),
        ),
      ),
    );
  }

   Widget _crearNombre(){
    
    return TextFormField(
      initialValue: salidaChofer.nombreChofer.toUpperCase(),
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline, color: Colors.green),
        labelText:'Nombre del chofer',
      ),
      onSaved: (value) => salidaChofer.nombreChofer = value.toLowerCase(),
      enabled: false,
    );
  }

  Widget _crearCedula(){
    
    return TextFormField(
      initialValue: salidaChofer.cedulaChofer.toString(),
      keyboardType: TextInputType.numberWithOptions(signed: true),
      decoration: InputDecoration(
        icon: Icon(Icons.border_color, color: Colors.green),
        labelText:'Cedula Identidad',
      ),
      onSaved: (value) => salidaChofer.cedulaChofer = int.parse(value),
      enabled: false,
    );
  }

  Widget _crearHora(){
    _timeValue();
    return Container(
      width: 150,
      child:TextFormField(
        controller: myController,
        // initialValue: hourFormat.format(DateTime.parse(salidaChofer.fechaHoraSalida)),
        decoration: InputDecoration(
          icon: Icon(Icons.timer, color: Colors.green),
          labelText: 'Hora Salida',
        ),
      onSaved: (value) => salidaChofer.fechaHoraSalida = fecha + value,
      validator: (value){
          if(value.length > 0){
            return null;
          }
          else{
            return 'Ingrese solo numeros';
          }
      },
      enabled: false,
      )
    );
  }

  Widget _crearMovil(){
    
    return TextFormField(
      initialValue: salidaChofer.movil.toString(),
      keyboardType: TextInputType.numberWithOptions(signed: true),
      decoration: InputDecoration(
        icon: Icon(Icons.directions_car, color: Colors.green),
        labelText:'Movil',
      ),
      onSaved: (value) => salidaChofer.movil = int.parse(value),
      validator: (value) => utils.isNumero(value)? null:'Ingrese solo numeros'
    );
  }

  Widget _crearEstado(){
    
    return SwitchListTile(
      value: salidaChofer.estado,
      title: Text('Estado'),
      activeColor: Colors.green,
      onChanged: (value)=> setState((){
        salidaChofer.estado=value;
      }),
    );
  }

  Widget _crearBotonHora(){

    return  Container(
      padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
      child: RaisedButton.icon(
        icon: Icon(Icons.add_alarm),
        label: Text('Agregar'),
        onPressed: () {
          DatePicker.showTimePicker(
            context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true, 
            onConfirm: (hora) {
              time = hora.toString();
              _timeValue();
              setState((){});
            }, 
            currentTime: DateTime.now(), locale: LocaleType.es 
          );
          setState(() {});
        },
      ),
    );
  }

  Widget _crearBotonGuardar(BuildContext context){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.green,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed:(){
        _registrarSalida(context);
      }
    );
  }

  void _registrarSalida(BuildContext context)async{
    
    if( !formKey.currentState.validate() ) return ;

    await loading.show();
    formKey.currentState.save();
    // if(snapSalida.documents.length==0)
    // {
      await salidaBloc.actualizarSalida(salidaChofer);
      await loading.hide();
      await utils.mostrarMensaje(context,'Actualizado con exito!');
      Navigator.of(context).pop();
    // }
    // else{
    //   await loading.hide();
    //   await utils.mostrarMensaje(context, 
    //   'ERROR: No se puede registrar al chofer ${salidaChofer.nombreChofer} tiene ruta con estado activo.');
    //   Navigator.of(context).pop();
    // }
     
  }

}
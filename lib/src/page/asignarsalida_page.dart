import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:trufi_app/src/model/salida_model.dart';
import 'package:trufi_app/src/model/usuario_model.dart';
import 'package:trufi_app/src/bloc/provider.dart';
import 'package:trufi_app/src/utils/utilidades_utils.dart' as utils;



class AsignarSalida extends StatefulWidget {
  
  @override
  _AsignarSalidaState createState() => _AsignarSalidaState();
}

class _AsignarSalidaState extends State<AsignarSalida> {

  SalidaBloc salidaBloc;
  SalidaModel salidaModel = new SalidaModel();
  final formKey = GlobalKey<FormState>();
  final DateFormat hourFormat = new DateFormat('HH:mm:ss');
  final myController = TextEditingController();
  String fecha=DateFormat('yyyy-MM-dd ').format(DateTime.now());  
  var uuid = new Uuid();
  ProgressDialog loading;  
  bool estado=true;
  String time;

  _timeValue() {
    myController.text=time;
  }
  
  @override 
  Widget build(BuildContext context) {
    
    salidaBloc = Provider.salidaBloc(context);
    loading = new ProgressDialog(context,isDismissible: false);
    utils.crearLoading(loading);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text('Asignar salida'),
      ),  
      body: _crearFormAsignarSalida(context)
    );
  }

   Widget _crearFormAsignarSalida(BuildContext context){
   
   final UsuarioModel usuario = ModalRoute.of(context).settings.arguments;
   
    return SingleChildScrollView(
      child:Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child:Column(
            children:<Widget>[
             _crearNombre(usuario),
             _crearCedula(usuario),
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

   Widget _crearNombre(UsuarioModel usuario){
    
    return TextFormField(
      initialValue: usuario.nombreUsuario.toUpperCase(),
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline, color: Colors.green),
        labelText:'Nombre del chofer',
      ),
      onSaved: (value) => salidaModel.nombreChofer = value.toLowerCase(),
      enabled: false,
    );
  }

  Widget _crearCedula(UsuarioModel usuario){
    
    return TextFormField(
      initialValue: usuario.cedula.toString(),
      keyboardType: TextInputType.numberWithOptions(signed: true),
      decoration: InputDecoration(
        icon: Icon(Icons.border_color, color: Colors.green),
        labelText:'Cedula Identidad',
      ),
      onSaved: (value) => salidaModel.cedulaChofer = int.parse(value),
      enabled: false,
    );
  }

  Widget _crearHora(){

    return Container(
      width: 150,
      child:TextFormField(
        controller: myController,
        decoration: InputDecoration(
          icon: Icon(Icons.timer, color: Colors.green),
          labelText: 'Hora Salida',
        ),
      onSaved: (value) => salidaModel.fechaHoraSalida = fecha+value,
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
        keyboardType: TextInputType.numberWithOptions(signed: true),
        decoration: InputDecoration(
          icon: Icon(Icons.directions_car, color: Colors.green),
          labelText:'Movil',
        ),
        onSaved: (value) => salidaModel.movil = int.parse(value),
        validator: (value){
          if(utils.isNumero(value)){
            return null;
          }
          else{
            return 'Ingrese solo numeros';
          }
        },
      );
  }

  Widget _crearEstado(){

    return SwitchListTile(
      value: salidaModel.estado,
      title: Text('Estado'),
      activeColor: Colors.green,
      onChanged: (value){}
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
              time = '${hourFormat.format(hora)}';
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
    salidaModel.id=uuid.v4();

    await salidaBloc.insertarSalida(salidaModel).then((value) async{
      
      if(value){
        await loading.hide();
        await utils.mostrarMensaje(context,'Registro exito!');
        Navigator.of(context).pop();
      }
      else{
        await loading.hide();
        await utils.mostrarMensaje(context, 
        'ERROR: No se puede registrar al chofer ${salidaModel.nombreChofer} tiene ruta con estado activo.');
        Navigator.of(context).pop();
      }

    });
     
  }

}
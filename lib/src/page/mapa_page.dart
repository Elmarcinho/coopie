import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'package:trufi_app/src/bloc/provider.dart';
import 'package:trufi_app/src/model/geovalla_model.dart';
import 'package:trufi_app/src/model/marcaje_model.dart';
import 'package:trufi_app/src/preferencia_usuario/preferencia_usuario.dart';
import 'package:trufi_app/src/provider/geovalla_provider.dart';
import 'package:trufi_app/src/provider/marcaje_provider.dart';
import 'package:trufi_app/src/provider/salida_provider.dart';
import 'package:trufi_app/src/utils/variable_utils.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MarcajeBloc marcajeBloc;
  final geoProvider = new GeoVallaProvider();
  final salidaProvider = new SalidaProvider();
  final marcajeProvider = new MarcajeProvider();
  final marcajeModel = new MarcajeModel();
  final prefs = new PreferenciasUsuario();
  GoogleMapController _controllermap;
  List<Marker> _listaMarcador = [];
  List<Circle> _listaCirculo = [];
  List<Geolocation> _listaGeoValla = [];
  MapType _mapaActual = MapType.normal;
  final scaffoldkey = GlobalKey<ScaffoldState>();
  bool estado = true;
  List<GeoVallaModel> geoValla;
  Location location = new Location();

  @override
  void initState() {
    super.initState();
    _iniciarLocation();
  }

  void _iniciarLocation() async {
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    subscription = location.onLocationChanged.listen((LocationData geoActual) {
      if (_controllermap != null) {
        _controllermap.animateCamera(CameraUpdate.newLatLng(
            LatLng(geoActual.latitude, geoActual.longitude)));
      }
    });
  }

  Future<void> _iniciarEventoGeoValla(BuildContext context) async {
    marcajeBloc = Provider.marcajeBloc(context);

    if (!mounted) return;

    Geofence.initialize();

    Geofence.startListening(GeolocationEvent.entry, (entry) async {

      var detalleSalida = await salidaProvider.detalleSalida(prefs.cedula, estado);

      if (detalleSalida.length > 0) {

        var marcaje = await marcajeProvider.traerMarcaje(prefs.cedula);

        marcajeModel.atraso = 0;
        marcajeModel.cedula = prefs.cedula;
        marcajeModel.chofer = prefs.nombreUsuario;
        marcajeModel.puntoMarcaje = entry.id;
        marcajeModel.fechaHoraMarcaje = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        marcajeModel.geo = entry.latitude.toString() + ', ' + entry.longitude.toString();
        DateTime fechaMarcaje = DateTime.parse(marcajeModel.fechaHoraMarcaje);
        String nombrePunto;
        int contar = 0;

        for (var item in detalleSalida) {

          if(contar==0) nombrePunto = item.nombreGeoPunto;

          if (item.nombreGeoPunto == entry.id) {

            if(nombrePunto != entry.id || (nombrePunto == entry.id && marcaje.length < 2)){

              marcajeModel.fecha = DateFormat('dd-MM-yyyy').format(DateTime.parse(item.fechaHoraSalida));
              marcajeModel.fechaHoraSalida = item.fechaHoraSalida;
              marcajeModel.fechaHoraLlegada = item.fechaHoraLlegada;
              marcajeModel.movil = item.movil;

              Duration atraso = fechaMarcaje.difference(DateTime.parse(item.fechaHoraLlegada));

              if (atraso.inMinutes > 0) marcajeModel.atraso = atraso.inMinutes.toInt();
              
              await marcajeBloc.insertarMarcaje(marcajeModel).then((value) {
                  if (value) 
                   _mostrarSnackbar("ENTRADA: ${entry.id}, ${marcajeModel.fechaHoraMarcaje}");
              });
              break;
            }
            else{

              await salidaProvider.actualizarSalidaEstado(item.id,false).then((value) {
                if (value) 
                 _mostrarSnackbar("Nuevo estado actualizado");
              });
              break;
            }
          }
          contar++;
        }
      }
    });

    Geofence.startListening(GeolocationEvent.exit, (exit) {
      _mostrarSnackbar("SALIDAAA:");
    });
  }

  @override
  Widget build(BuildContext context) {
    _iniciarEventoGeoValla(context);

    return Scaffold(
      key: scaffoldkey,
      body: _crearGoogleMapa(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(296, 0, 0, 330),
        child: _crearBotonFlotante(),
      ),
    );
  }

  Widget _crearGoogleMapa() {
    return FutureBuilder<List<GeoVallaModel>>(
      future: geoProvider.traerListaGeoValla(),
      builder:
          (BuildContext context, AsyncSnapshot<List<GeoVallaModel>> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        for (var i = 0; i < snapshot.data.length; i++) {
          var a = snapshot.data[i].geo.split(',');
          _listaMarcador.add(new Marker(
              markerId: MarkerId(snapshot.data[i].nombre),
              position: LatLng(double.parse(a[0]), double.parse(a[1])),
              infoWindow:
                  InfoWindow(title: snapshot.data[i].nombre.toUpperCase())));
          _listaCirculo.add(new Circle(
              circleId: CircleId(snapshot.data[i].nombre),
              center: LatLng(double.parse(a[0]), double.parse(a[1])),
              radius: (snapshot.data[i].radio).toDouble(),
              strokeColor: Colors.green,
              fillColor: Colors.yellow));
          _listaGeoValla.add(new Geolocation(
              id: snapshot.data[i].nombre,
              latitude: double.parse(a[0]),
              longitude: double.parse(a[1]),
              radius: (snapshot.data[i].radio).toDouble()));
          Geofence.addGeolocation(_listaGeoValla[i], GeolocationEvent.entry);
        }

        return GoogleMap(
          mapType: _mapaActual,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          initialCameraPosition: CameraPosition(
            target: LatLng(-17.742389, -63.050725),
            zoom: 15.0,
          ),
          markers: Set.from(_listaMarcador),
          circles: Set.from(_listaCirculo),
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controllermap = controller;
            setState(() {});
          },
        );
      },
    );
  }

  Widget _crearBotonFlotante() {
    return FloatingActionButton(
        child: Icon(Icons.map, color: Colors.black54),
        backgroundColor: Colors.white70,
        mini: true,
        onPressed: () {
          _mapaActual = _mapaActual == MapType.normal
              ? MapType.satellite
              : MapType.normal;
          setState(() {});
        });
  }

  void _mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2770),
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }
}

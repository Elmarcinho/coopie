import 'package:flutter/material.dart';

import 'package:trufi_app/src/bloc/provider.dart';
import 'package:trufi_app/src/page/actualizarsalida_page.dart';
import 'package:trufi_app/src/page/asignarsalida_page.dart';
import 'package:trufi_app/src/page/geovalla_page.dart';
import 'package:trufi_app/src/page/home_page.dart';
import 'package:trufi_app/src/page/login_page.dart';
import 'package:trufi_app/src/page/mapa_page.dart';
import 'package:trufi_app/src/page/usuario_page.dart';
import 'package:trufi_app/src/page/salida_page.dart';
import 'package:trufi_app/src/page/setting_page.dart';
import 'package:trufi_app/src/preferencia_usuario/preferencia_usuario.dart';

 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());  
} 
 
class MyApp extends StatelessWidget {
  
  final prefs = new PreferenciasUsuario();
 
  @override
  Widget build(BuildContext context) {
    String ruta;
    prefs.token!=''? ruta='home':ruta='login';
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,  
        title: 'CooPie',
        initialRoute: ruta,
        routes: {
          'login'      :(BuildContext context) => LoginPage(),
          'home'       :(BuildContext context) => HomePage(),
          'mapa'       :(BuildContext context) => MapaPage(),
          'geovalla'   :(BuildContext context) => GeoVallaPage(),
          'registrouser' :(BuildContext context) => RegistroUserPage(),
          'listasalida':(BuildContext contex)  => SalidaPage(),
          'asignarsalida':(BuildContext contex)=>  AsignarSalida(),
          'actualizarsalida':(BuildContext contex)=>  ActualizarAsignarSalida(),
          'ajuste'       :(BuildContext context) => SettingPage(),  
        },
        theme: ThemeData(
          primaryColor: Colors.green, 
        ),
      ),
    );
  }
} 
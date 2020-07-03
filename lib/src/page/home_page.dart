import 'package:flutter/material.dart';

import 'package:location/location.dart';

import 'package:trufi_app/src/page/mapa_page.dart';
import 'package:trufi_app/src/page/marcaje_page.dart';
import 'package:trufi_app/src/page/detalleSalida_page.dart';
import 'package:trufi_app/src/wigets/menu_widget.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Location location = new Location();
  int pagina = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cooperativa Piedades'),
        centerTitle: true
      ),
      drawer: MenuWidget(),
      body: cargarPagina(pagina),
      bottomNavigationBar: _crearBotonNavegador(),
    );
  } 

   Widget _crearBotonNavegador(){

    return BottomNavigationBar( 
      currentIndex: pagina,
      onTap: (index){
        setState(() {
          pagina = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Salida')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          title: Text('Ubicacion')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          title: Text('Marcaje')
        )
      ],
    );
  } 

   Widget cargarPagina(int paginaActual){

    switch (paginaActual) {
      case 0:
        return SalidaPage();
        break;
      case 1:
        return MapaPage();
        break;
      default:
        return MarcajePage();
    }

  }


}
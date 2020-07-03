import 'package:flutter/material.dart';

import 'package:trufi_app/src/model/usuario_model.dart';
import 'package:trufi_app/src/provider/usuario_provider.dart'; 



class DataSearch extends SearchDelegate{

   DataSearch() : super(
        searchFieldLabel: "Buscar",
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
   ); 
   ThemeData appBarTheme(BuildContext context) {  
    return Theme.of(context); 
   }

  final choferProvider = new UsuarioProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
      //
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            query='';
          },  
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      //
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation, 
        ),
        onPressed: (){
          close(context, 
          null 
        );
        },
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // 
      return Container();
    } 
  
    @override
    Widget buildSuggestions(BuildContext context) {
    //
      if(query.isEmpty) return  Container();

      return FutureBuilder(
        future: choferProvider.getbuscarUsuario (query.toLowerCase()),
        builder: (BuildContext context, AsyncSnapshot<List<UsuarioModel>> snapshot) {

          if(!snapshot.hasData){return Center (child: CircularProgressIndicator());}

          return ListView(  
            children: snapshot.data.map((usuario){
              return ListTile(
                // leading: FadeInImage(
                //   placeholder: null, 
                //   image: null
                // ),
                title: Text(usuario.nombreUsuario.toUpperCase()),
                subtitle: Text('CI: ${usuario.cedula}'),
                onTap: (){ 
                  close(context,null);
                  Navigator.pushNamed(context, 'asignarsalida',arguments: usuario);
                },
              );
            }).toList(),
          );
        },
      );
    }
  

}


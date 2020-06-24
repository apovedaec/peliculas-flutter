import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
      // TODO: implement buildActions(acciones del appBar)
      return [
        IconButton(icon: Icon(Icons.clear), onPressed: (){
              query = '';
        })
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // TODO: implement buildLeading (icono a la izquierda del appBar)
      return IconButton(
                    icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), 
                    onPressed: (){
                      close(context, null);
                    });
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // TODO: implement buildResults(crea los resultados a mostrar)
      return Center(
        child: Container(
          height: 100.0,
          color: Colors.indigoAccent,
          child: Text(seleccion),
        ),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions(las sugerencias de la busqueda)
    if(query.isEmpty){
      return Container();
    } else {
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if(snapshot.hasData){
                return ListView(
                  children: snapshot.data.map((pelicula) {
                    return ListTile(
                          leading: FadeInImage(
                                placeholder: AssetImage('assets/img/loading.gif'), 
                                image: NetworkImage(pelicula.getPosterImg()),
                                width: 50.0,
                                fit: BoxFit.contain,),
                          title: Text(pelicula.title),
                          subtitle: Text(pelicula.originalTitle),
                          onTap: (){
                            pelicula.uniqueId = '';
                            close(context, null);
                            Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                          },
                    );
                  }).toList(),
                );
          } else {
                return Center(child: CircularProgressIndicator(),);
          }
        },
      );
    }
  }

}
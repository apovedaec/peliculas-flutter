import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  
  const PeliculaDetalle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          SliverList(delegate: SliverChildListDelegate(
            [
              SizedBox(height: 10.0,),
              _posterTitulo(context, pelicula),
              _descripcion(pelicula),
              _crearCasting(pelicula),
            ]
            ))
        ],
      )
    );
  }

 Widget _crearAppBar(Pelicula pelicula) {
   return SliverAppBar(
     elevation: 2.0,
     backgroundColor: Colors.indigoAccent,
     expandedHeight: 200.0,
     floating: false,
     pinned: true,
     flexibleSpace: FlexibleSpaceBar(
       centerTitle: true,
       title: Text(pelicula.title),
       background: FadeInImage(
                        placeholder: AssetImage('assets/img/loading.gif'), 
                        image: NetworkImage(pelicula.getBackdropPathImg()),
                        fadeInDuration: Duration(milliseconds: 150),
                        fit: BoxFit.cover,
                        ),
     ),
   );
 }

 Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(image: NetworkImage(pelicula.getPosterImg()), height: 150.0,)),
          ),
            SizedBox(width: 20.0,),
            Flexible(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle2, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString())
                  ],
                )
              ],
            ))
        ],
      ),
    );
  }

 Widget _descripcion(Pelicula pelicula) {
   return Container(
     padding: EdgeInsets.all(15.0),
     child: Text(pelicula.overview, textAlign: TextAlign.justify,),
   );
 }

 Widget _crearCasting(Pelicula pelicula) {
   final peliProvider = new PeliculasProvider();
   return FutureBuilder(
     future: peliProvider.getActores(pelicula.id.toString()),
     builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
     },
   );
 }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(context, actores[i]),        
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        ),
    );
  }

  Widget _actorTarjeta(BuildContext context, Actor actor){
      return Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                          placeholder: AssetImage('assets/img/no-image.jpg'), 
                          image: NetworkImage(actor.getFoto()),
                          height: 150.0,
                          fit: BoxFit.cover,)
                          ),
            Text(actor.name, style: Theme.of(context).textTheme.subtitle2, overflow: TextOverflow.ellipsis,)
          ],
        ),
      );
  }
}
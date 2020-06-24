import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = '19622b991928a26e0cdd351a1cbc7f71';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;
  List<Pelicula> _populares = new List();
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesaRespuesta(Uri url) async {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
      final decodeData = jsonDecode(resp.body);
      final peliculas = new Peliculas.fromJsonList(decodeData['results']);
      return peliculas.items;
      } else {
        return null;
      }
  }

  Future<List<Pelicula>> getEnCines() async {
      final url = Uri.https(_url, '3/movie/now_playing',{
        'api_key' : _apiKey,
        'language' : _language
      });

      return await _procesaRespuesta(url);
  }

    Future<List<Pelicula>> getPopulares() async {
      if(_cargando) return [];
      _cargando = true;
      _popularesPage++;
      final url = Uri.https(_url, '3/movie/popular',{
        'api_key' : _apiKey,
        'language' : _language,
        'page' : _popularesPage.toString()
      });

      final resp = await _procesaRespuesta(url);
      _populares.addAll(resp);
      popularesSink(_populares);
      _cargando = false;
      return resp;
  }

  Future<List<Actor>> getActores(String peliculaId) async {
      final url = Uri.https(_url, '3/movie/$peliculaId/credits',{
        'api_key' : _apiKey
      });

      final resp = await http.get(url);
      final decodeData = jsonDecode(resp.body);
      final actores = new Actores.fromJsonList(decodeData['cast']);
      return actores.items;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
      final url = Uri.https(_url, '3/search/movie',{
        'api_key' : _apiKey,
        'language' : _language,
        'query': query
      });

      return await _procesaRespuesta(url);
  }
}
class Actores {
  List<Actor> items = new List();
  Actores();
  Actores.fromJsonList(List<dynamic> jsonList){
      if(jsonList == null){
        return;
      } else {
        jsonList.forEach((item) { 
          final actor = new Actor.fromJsonMap(item);
          items.add(actor);
        });
      }
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap(Map<String, dynamic> json){
      castId      = json['cast_id'];
      character   = json['character'];
      creditId    = json['credit_id'];
      gender      = json['gender'];
      id          = json['id'];
      name        = json['name'];
      order       = json['order'];
      profilePath = json['profile_path'];
  }

    getFoto(){
      if(profilePath == null){
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQn_abQ0ko6CuA9LMsgv-JWMVJhGQboWlZDlUoZHeZ33cFwr2Ds&usqp=CAU';
      } else {
        return 'https://image.tmdb.org/t/p/w500/$profilePath';
      }
  }
}




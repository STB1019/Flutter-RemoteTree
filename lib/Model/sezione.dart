class Sezione {
  int id;
  String title;
  //Qui sarebbe da definire un enum/String per il tipo della sezione
  // per ora lasciamo la sezione generica
  List<String> subtitles;
  //Non posso immagazzinarlo

  Sezione(this.id, this.title, {this.subtitles});

  factory Sezione.fromMap(Map<String, dynamic> map) {
    return Sezione(
      map["id"],
      map["title"],
      subtitles: (map["subtitle"] as String).split("###"),
    );
  }

  Map<String, dynamic> toSQL() {
    return {
      "id": this.id,
      "title": this.title.trim(),
      "subtitle": this.subtitles.join(
          "###"), //Metodo per separare i sottotitoli e salvarli in un unica stringa
    };
  }
}

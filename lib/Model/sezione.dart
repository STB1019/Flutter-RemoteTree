class Sezione {
  int id;
  String title;
  List<String> subtitles;

  //Per ora la struttura del DB è di test -> Soluzione migliore
  //ID Integer, Type String, Data String (Json)

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
      "title": this.title,
      "subtitle": this.subtitles.join("###"),
      //Metodo per separare i sottotitoli e salvarli in un unica stringa, tutto questo è
      //da sostituire con un Json
    };
  }
}

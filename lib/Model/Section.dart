import 'dart:convert';
//Questa classe serve a parsare direttamente il Json completo
class ListSection {
  ListSection({
    this.buttonSection,
    this.webSection,
  });

  List<ButtonSection> buttonSection;
  List<WebSection> webSection;

  factory ListSection.fromJson(String str) => ListSection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListSection.fromMap(Map<String, dynamic> json) => ListSection(
    buttonSection: List<ButtonSection>.from(json["buttonSection"].map((x) => ButtonSection.fromMap(x))),
    webSection: List<WebSection>.from(json["webSection"].map((x) => WebSection.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "buttonSection": List<dynamic>.from(buttonSection.map((x) => x.toMap())),
    "webSection": List<dynamic>.from(webSection.map((x) => x.toMap())),
  };
}


abstract class GenericSection{
  int id;
  String title;
}
class ButtonSection extends GenericSection {
  ButtonSection({
    this.id,
    this.title,
    this.buttonlinks,
  });

  int id;
  String title;
  List<Buttonlink> buttonlinks;

  factory ButtonSection.fromJson(String str) => ButtonSection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ButtonSection.fromMap(Map<String, dynamic> json) => ButtonSection(
    id: json["id"],
    title: json["title"],
    buttonlinks: List<Buttonlink>.from(json["buttonlinks"].map((x) => Buttonlink.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "buttonlinks": List<dynamic>.from(buttonlinks.map((x) => x.toMap())),
  };
}

class Buttonlink {
  Buttonlink({
    this.button,
    this.link,
  });

  String button;
  int link;

  factory Buttonlink.fromJson(String str) => Buttonlink.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Buttonlink.fromMap(Map<String, dynamic> json) => Buttonlink(
    button: json["button"],
    link: json["link"],
  );

  Map<String, dynamic> toMap() => {
    "button": button,
    "link": link,
  };
}

class WebSection extends GenericSection {
  WebSection({
    this.id,
    this.title,
    this.link,
  });

  int id;
  String title;
  String link;

  factory WebSection.fromJson(String str) => WebSection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WebSection.fromMap(Map<String, dynamic> json) => WebSection(
    id: json["id"],
    title: json["title"],
    link: json["link"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "link": link,
  };
}

import 'package:flutter/material.dart';
import 'package:remote_tree/Model/Section.dart';

//Ancora da migliorare
Widget genericButton(String id) {
  return FlatButton(
    onPressed: () => print("Bottone generico premuto: $id"),
    child: genericText(id),
  );
}

//Ancora da migliorare
Widget genericText(String str, {bool bold = false}) {
  return Text(
    str,
    textAlign: TextAlign.center,
    style: TextStyle(
        fontSize: 19.0,
        fontWeight: (bold) ? FontWeight.bold : FontWeight.normal),
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  );
}

//Test per l'uso dei Widget per ideare un'ipotetica sezione
Widget buildSection(ButtonSection sezione) {
  int id = sezione.id;
  String title = sezione.title;
  List<ButtonLink> subtitles = sezione.buttonslinks;

  //titolo
  Widget titolo = genericText("$id : " + title, bold: true);

  //bottoni

  List<Widget> widgets = new List<Widget>();
  subtitles.forEach((element) {
    widgets.add(Expanded(
        child: FlatButton(
            onPressed: () {
              print("TODO Manda alla sezione nr ${element.link}");
            },
            child: genericText(element.button))));
  });
  widgets.insert(0, titolo);
  return Card(
    color: Colors.deepPurple[100],
    margin: EdgeInsets.all(10.0),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: widgets,
      ),
    ),
  );
}

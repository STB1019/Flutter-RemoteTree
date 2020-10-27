import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget genericButton(String id) {
  return FlatButton(
    onPressed: () => print("Bottone generico premuto: $id"),
    child: genericText(id),
  );
}

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

Widget genericSection(String title, List<String> subtitles) {
  Widget titolo = genericText(title, bold: true);
  List<Widget> widgets = new List<Widget>();
  subtitles.forEach((element) {
    widgets.add(Column(children: [
      Divider(height: 15.0,),
      Row(
        children: [
          Expanded(child: genericText(element)),
          Expanded(child: genericButton(element))
        ],
      )
    ]));
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

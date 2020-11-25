import 'package:flutter/material.dart';
import 'package:remote_tree/Model/Section.dart';
import 'package:url_launcher/url_launcher.dart';

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

//Crea una sezione dato contesto e file del model

Widget buildSection(BuildContext context, GenericSection sezione) {
  if (sezione is ButtonSection){
  int id = sezione.id;
  String title = sezione.title;
  List<ButtonLink> subtitles = sezione.buttonlinks;

  //titolo
  Widget titolo = genericText("$id : " + title, bold: true);


  List<Widget> widgets = new List<Widget>();
  subtitles.forEach((element) {
    widgets.add(FlatButton(
      color: Colors.deepPurple[300],
            onPressed: () {
              print("TODO Manda alla sezione nr ${element.link}");
            },
            child: genericText(element.button)));
  });
  widgets.insert(0, Divider());
  widgets.insert(0, titolo);
  return Card(
    color: Colors.deepPurple[100],
    margin: EdgeInsets.all(10.0),
    child: InkWell(
      splashColor: Colors.pink,
      onLongPress: (){
        print("TODO: Manda a detailedSezione");
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: widgets,
        ),
      ),
    ),
  );}
  else if (sezione is WebSection){
    return Card(
      color: Colors.orange[100],
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        child: Container(height: 100, child: Center(child: genericText(sezione.title, )),),
        onTap: () async{
          if(await canLaunch(sezione.link))
            await launch(sezione.link);

          }
      )
    );
  }
  return Container(child: Center(child: Text("ERROR"),),);
}
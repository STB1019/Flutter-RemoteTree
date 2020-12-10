import 'package:flutter/material.dart';
import 'package:remote_tree/Model/Section.dart';
import 'package:remote_tree/View/ButtonSectionPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ImageSectionPage.dart';

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
    textAlign: TextAlign.left,
    style: TextStyle(
      color: Colors.white,
        fontSize: 19.0,
        fontWeight: (bold) ? FontWeight.bold : FontWeight.normal),
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  );
}
//TODO aggiornare per nuove tipologie di sezione
Widget listTileFromSection(String title, Icon icon, Function onTap) {
  return Padding(
    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 35, left: 35),
    child: Container(
      decoration: BoxDecoration(color: Color(0xFF34ace0),borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title:genericText(title, bold: true),
        leading: icon,
        onTap: onTap,
      ),
    ),
  );
}

//Costruisce il body della HomePage fornita la lista di sezioni
List<Widget> buildHome(BuildContext cx, List<GenericSection> list) {
  var widgets = List<Widget>();
  widgets.add(Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      "Elenco Sezioni",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    ),
  ));
  widgets.add(Divider());
  list.forEach((section) {
    if (section is ButtonSection) {
      widgets.add(listTileFromSection(
          section.title,
          Icon(Icons.book, color: Colors.white,),
          () => Navigator.push(
                cx,
                MaterialPageRoute(builder: (cx) {
                  return ButtonSectionPage(section);
                }),
              )));
    } else if (section is WebSection) {
      widgets.add(listTileFromSection(
          section.title, Icon(Icons.open_in_browser,color: Colors.white,), () async {
        Scaffold.of(cx).showSnackBar(
            SnackBar(content: Text("Apertura link nel browser predefinito")));
        if (await canLaunch(section.link)) await launch(section.link);
      }));
    }
    else if( section is ImageSection){
      widgets.add(listTileFromSection(section.title, Icon(Icons.image, color: Colors.white,), ()=> Navigator.push(cx, MaterialPageRoute(builder: (cx){
        return ImageSectionPage(section);
      }))));
    }
    else {
      return null;
    }
  });
  return widgets;
}

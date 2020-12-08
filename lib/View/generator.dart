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
    textAlign: TextAlign.center,
    style: TextStyle(
        fontSize: 19.0,
        fontWeight: (bold) ? FontWeight.bold : FontWeight.normal),
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  );
}
//TODO aggiornare per nuove tipologie di sezione
Widget listTileFromSection(String title, Icon icon, Function onTap) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: ListTile(
      tileColor: Color(0xFFBB86FC),
      title: Center(child: genericText(title)),
      leading: icon,
      onTap: onTap,
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
          Icon(Icons.book),
          () => Navigator.push(
                cx,
                MaterialPageRoute(builder: (cx) {
                  return ButtonSectionPage(section);
                }),
              )));
    } else if (section is WebSection) {
      widgets.add(listTileFromSection(
          section.title, Icon(Icons.open_in_browser), () async {
        Scaffold.of(cx).showSnackBar(
            SnackBar(content: Text("Apertura link nel browser predefinito")));
        if (await canLaunch(section.link)) await launch(section.link);
      }));
    }
    else if( section is ImageSection){
      widgets.add(listTileFromSection(section.title, Icon(Icons.image), ()=> Navigator.push(cx, MaterialPageRoute(builder: (cx){
        return ImageSectionPage(section);
      }))));
    }
    else {
      return null;
    }
  });
  return widgets;
}

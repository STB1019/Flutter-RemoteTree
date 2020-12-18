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
Widget genericText(String str, {bool bold = false, Color tcolr = Colors.white}) {
  return Text(
    str,
    textAlign: TextAlign.left,
    style: TextStyle(
        color: tcolr,
        fontSize: 19.0,
        fontWeight: (bold) ? FontWeight.bold : FontWeight.normal),
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  );
}

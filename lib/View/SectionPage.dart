import 'package:flutter/material.dart';
import 'package:remote_tree/Model/Section.dart';
import 'generator.dart';

//Per ora funziona solo per una tipologia di sezione
class ButtonSectionPage extends StatefulWidget {
  final ButtonSection _section;
  ButtonSectionPage(this._section);
  @override
  _ButtonSectionPageState createState() => _ButtonSectionPageState();
}

class _ButtonSectionPageState extends State<ButtonSectionPage> {
  @override
  Widget build(BuildContext context) {
    var section = widget._section;

    var title = Padding(padding: EdgeInsets.all(12),child:Text(section.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        )));
    var children = List<Widget>();
    children.add(title);
    children.add(Divider());
    section.buttonlinks.forEach((element) {
      children.add(FlatButton(
            color: Colors.purple,
            onPressed: () {
              print("TODO Manda alla sezione nr ${element.link}");
            },
            child: genericText(element.button)),
      );
    });
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.greenAccent,
      body: Card(
        color: Colors.deepOrangeAccent[100],
        margin: EdgeInsets.all(10.0),
        child: Center(child: Column(children: children)),
      ),
    );
  }
}

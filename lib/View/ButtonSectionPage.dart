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
    var buttons = List<Widget>();
    section.buttonlinks.forEach((element) {
      buttons.add(FlatButton(padding: EdgeInsets.all(30.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            color: Color(0xFF8C3CFF),
            onPressed: () {
              print("TODO Manda alla sezione nr ${element.link}");
            },
            child: genericText(element.button)),
      );
    });
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Color(0xFFE5D1FE),
      body: Card(
        elevation: 4,
        margin: EdgeInsets.all(30),
        color: Color(0xFF34ace0),
        child: Column(
          children: [
            title,
            Divider(),
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: buttons),
            ),
          ],
        )
      ),
    );
  }
}

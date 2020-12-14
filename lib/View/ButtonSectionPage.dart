import 'package:flutter/material.dart';
import 'package:remote_tree/Model/Section.dart';
import 'package:remote_tree/View/PDFSectionPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ImageSectionPage.dart';
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
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        )));
    var buttons = List<Widget>();
    section.buttonlinks.forEach((element) {
      buttons.add(FlatButton(padding: EdgeInsets.all(30.0),
            color: Theme.of(context).buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            onPressed: () {
            var sectionToGo;
              switch (element.type){
                case "Image" :
                  sectionToGo = ImageSection(id: 1, title: element.button, imagelink: element.link);
                  Navigator.push(context,  MaterialPageRoute(builder: (cx) {
                    return ImageSectionPage(sectionToGo);
                  }));
                  break;
                case "Web" :
                  launch(element.link);
                  break;
                case "PDF" :
                  sectionToGo = PDFSection(id: 1, title: element.button, link: element.link);
                  Navigator.push(context,  MaterialPageRoute(builder: (cx) {
                    return PDFSectionPage(sectionToGo);
                  }));
                  break;
                default: sectionToGo = null;
              }

            },
            child: genericText(element.button)),
      );
    });
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Card(
        elevation: 4,
        margin: EdgeInsets.all(30),
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

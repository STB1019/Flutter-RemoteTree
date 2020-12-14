import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:remote_tree/Model/Section.dart';
import 'package:remote_tree/View/PDFSectionPage.dart';
import 'package:remote_tree/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ButtonSectionPage.dart';
import 'DataProvider.dart';
import 'ImageSectionPage.dart';
import 'generator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<ListSection> currentData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentData = DataProvider.of(context).databaseHelper.getCurrentData();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Remote Tree"),
        actions: [
          PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              color: Colors.white,
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) {
                var list = List<PopupMenuItem<String>>();
                list.add(PopupMenuItem(
                    child: ListTile(
                  trailing: Icon(Icons.sync),
                  title: Text("Aggiorna"),
                  onTap: () {
                    setState(() {
                      //Update del DB
                      currentData = DataProvider.of(context)
                          .databaseHelper
                          .getCurrentData();
                    });
                  },
                )));
                list.add(PopupMenuItem(
                    child: ListTile(
                  trailing: Icon(Icons.settings),
                  title: Text("Impostazioni"),
                  onTap: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("TODO"),
                      action: SnackBarAction(
                        label: "Chiudi",
                        onPressed: () =>
                            Scaffold.of(context).hideCurrentSnackBar(),
                      ),
                      duration: Duration(seconds: 1),
                    ));
                  },
                )));
                return list; //Lista di bottoni
              }),
        ],
      ),
      //Per ora corrisponde solo ad un body con una serie di sezioni
      body: buildBody(),
    );
  }

  Widget buildBody() {
    var sectionCard = FutureBuilder(
      future: databaseHelper
          .getCurrentData(), //Necessario per evitare problemi nel caricamento
      builder: (context, snapshot) {
        Widget widgetToShow;
        if (snapshot.hasError) {
          widgetToShow = Center(
              child: Text(
                  "Errore nell'inizializzazione del DB \n Si prega ti premere il bottone in alto a destra per aggiornare"));
          print(snapshot.error);
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          widgetToShow = Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
                elevation: 5,
                child: Column(
                    children: buildCardSection(
                        context, snapshot.data.getAllSections()))),
          );
        } else {
          // Dati non ancora pronti
          widgetToShow = Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 50,
              ),
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Attesa risultati...',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ]),
          );
        }
        return widgetToShow;
      },
    );
    return ListView(
      children: [
        Container(
          height: 250,
          child: Card(
            color: Colors.white70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: "User",
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        NetworkImage("https://placekitten.com/200/300"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Massimiliano Tummolo",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Amministratore",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        sectionCard,
      ],
    );
  }
}

//Helper functions

//TODO aggiornare per nuove tipologie di sezione
Widget listTileFromSection(String title, Icon icon, Function onTap) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 35, left: 35),
    child: Container(
      decoration: BoxDecoration(
          color: Color(0xFF0077B6), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: genericText(title, bold: true),
        leading: icon,
        onTap: onTap,
      ),
    ),
  );
}

//Costruisce il body della HomePage fornita la lista di sezioni
List<Widget> buildCardSection(BuildContext cx, List<GenericSection> list) {
  var widgets = List<Widget>();

  widgets.add(Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      "Elenco Sezioni",
      style: TextStyle(
        color: Colors.white,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    ),
  ));

  widgets.add(Divider());

  //TODO questa parte si può modificare
  // aggiungendo dati alle sezioni per immagazzinare roba
  list.forEach((section) {
    if (section is ButtonSection) {
      widgets.add(listTileFromSection(
          section.title,
          Icon(
            Icons.book,
            color: Colors.white,
          ),
          () => Navigator.push(
                cx,
                MaterialPageRoute(builder: (cx) {
                  return ButtonSectionPage(section);
                }),
              )));
    } else if (section is WebSection) {
      widgets.add(listTileFromSection(
          section.title,
          Icon(
            Icons.open_in_browser,
            color: Colors.white,
          ), () async {
        Scaffold.of(cx).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text("Apertura link nel browser predefinito")));
        if (await canLaunch(section.link)) {
          await launch(section.link);
        }
      }));
    } else if (section is ImageSection) {
      widgets.add(listTileFromSection(
          section.title,
          Icon(
            Icons.image,
            color: Colors.white,
          ),
          () => Navigator.push(cx, MaterialPageRoute(builder: (cx) {
                return ImageSectionPage(section);
              }))));
    } else if (section is PDFSection) {
      widgets.add(listTileFromSection(
          section.title,
          Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
          ),
          () => Navigator.push(cx, MaterialPageRoute(builder: (cx){
            return PDFSectionPage(section);
          }))));
    } else {
      return null;
    }
  });
  return widgets;
}

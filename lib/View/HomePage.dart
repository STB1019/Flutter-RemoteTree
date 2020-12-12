import 'package:flutter/material.dart';
import 'package:remote_tree/Model/Section.dart';
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
      //Ho provato ad usare una appBar personalizzata leggermente curva
      drawer: Drawer(
        child: buildDrawer(context),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Remote Tree"),
        actions: [
          IconButton(
              icon: Icon(Icons.update),
              onPressed: () {
                setState(() {
                  //Update del DB
                  currentData =
                      DataProvider.of(context).databaseHelper.getCurrentData();
                });
              })
        ],
      ),
      //Per ora corrisponde solo ad un body con una serie di sezioni
      body: buildBody(),
    );
  }

  FutureBuilder<ListSection> buildBody() {
    return FutureBuilder(
      future: currentData, //Necessario per evitare problemi nel caricamento
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
                child: ListView(
                    shrinkWrap: true,
                    children:
                        buildHome(context, snapshot.data.getAllSections()))),
          );
        } else {
          // Dati non ancora pronti
          widgetToShow = Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
  }
}

//Helper functions
ListView buildDrawer(BuildContext context) {
  return ListView(
    padding: EdgeInsets.zero,
    children: [
      UserAccountsDrawerHeader(
        accountName: Text("Massimiliano Tummolo"),
        accountEmail: Text("max.tummolo@gmail.com"),
        currentAccountPicture: CircleAvatar(backgroundColor: Theme.of(context).backgroundColor, child: Text("M"),),
      ),
      ListTile(title: Text("HomePage")),
      ListTile(title: Text("Settings"), trailing: Icon(Icons.settings),
          onTap: ()=> Navigator.of(context).pushNamed("/settings"))
    ],
  );
}

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
List<Widget> buildHome(BuildContext cx, List<GenericSection> list) {
  var widgets = List<Widget>();

  widgets.add(Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      "Elenco Sezioni",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
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
        if (await canLaunch(section.link)) await launch(section.link);
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
    } else {
      return null;
    }
  });
  return widgets;
}

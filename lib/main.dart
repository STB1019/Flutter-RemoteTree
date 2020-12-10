import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:remote_tree/Model/Section.dart';

import '__init__.dart' as commons_widgets;
import 'Provider/db_helper.dart' as DBMS;

//Import per init del DB a braccio
import 'dart:convert';

void main() {
  runApp(MyApp());
  initDatabase();
}

DBMS.DatabaseHelper databaseHelper;

initDatabase() async{
  //Simulazione dataset fornito da un DB -> Manca la differenziazione
  // fra le varie tipologie di sezione
  databaseHelper = DBMS.DatabaseHelper();
  //Inizializzazione DB
  //Parsing json in init -> ogni volta il db viene ri-inizializzato
  String contents = await rootBundle.loadString('assets/sezioniDiBase.json');
  var listSections = ListSection.fromJson(contents);
  //TODO
  //Inserimento sezioni
  databaseHelper.insertCompleteSection(listSections);
  print("Sezioni inserite");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Remote Tree',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Remote Tree'),
      );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Al momento quando faccio la select * dal db mi ritorna con l'interfaccia
  //getAll() una lista di sezioni, potrei far ritornare una mappa? o una struttura diversa?
  // Avrebbe senso? -> TODO Mettere InheritedWidgets
  Future<ListSection> currentData;

  @override
  void initState() {
    super.initState();
    currentData = databaseHelper.getCurrentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5D1FE),
      //Ho provato ad usare una appBar personalizzata leggermente curva
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text(widget.title),
        leading: IconButton(icon: Icon(Icons.info), onPressed:(){
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: new Text("Remote Tree"),
                content: Text("Questa applicazione si interfaccia "
                    "con un file json per specificare "
                    "una serie di sezioni adibite a scopi vari"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Chiudi'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
        }),
        actions: [
          IconButton(icon: Icon(Icons.update), onPressed: (){
            setState(() {
              //Update del DB
              currentData = databaseHelper.getCurrentData();
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
          widgetToShow = Center(child: Text("Errore nell'inizializzazione del DB \n Si prega ti premere il bottone in alto a destra per aggiornare"));
          print(snapshot.error);
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          widgetToShow = Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(elevation: 5,child: ListView(shrinkWrap: true,children:
                commons_widgets.buildHome(context, snapshot.data.getAllSections()))
         ),
          );
        } else { // Dati non ancora pronti
          widgetToShow = Center(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center ,
                children: [
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Attesa risultati...', style: TextStyle(fontSize: 18.0,),),
              ),
            ]),
          );
        }
        return widgetToShow;
      },
    );
  }
}

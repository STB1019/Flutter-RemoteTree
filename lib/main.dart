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
  //Parsing json in init
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
          primarySwatch: Colors.deepPurple,
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
      backgroundColor: Colors.greenAccent,
      //Ho provato ad usare una appBar personalizzata leggermente curva
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
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
          widgetToShow = Text("Errore nell'inizializzazione del DB");
          print(snapshot.error);
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          widgetToShow = ListView(children:
              commons_widgets.buildHome(context, snapshot.data.getAllSections())
         );
        } else { // Dati non ancora pronti
          widgetToShow = Column(
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
          ]);
        }
        return Center(
          child: widgetToShow,
        );
      },
    );
  }
}

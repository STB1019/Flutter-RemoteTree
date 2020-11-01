import 'package:flutter/material.dart';
import '__init__.dart' as commons_widgets;
import 'Provider/db_helper.dart' as DBMS;
import 'package:remote_tree/Model/sezione.dart';

void main() {
  runApp(MyApp());
  initDatabase();
}

DBMS.DatabaseHelper databaseHelper;

initDatabase() {
  //Simulazione dataset fornito da un DB -> Manca la differenziazione
  // fra le varie tipologie di sezione
  databaseHelper = DBMS.DatabaseHelper();
  //Inizializzazione DB
  databaseHelper.initDb();

  List<Sezione> sezioni = List<Sezione>();
  sezioni.add(Sezione(1, "Informatica", subtitles: ["1", "2", "3", "4"]));
  sezioni.add(Sezione(2, "Analisi I", subtitles: ["5", "6", "7", "8"]));
  sezioni.add(Sezione(3, "Analisi II", subtitles: ["9", "10", "11", "12"]));
  sezioni.add(Sezione(4, "Analisi III", subtitles: ["9", "10", "11", "12"]));
  //Inserimento sezioni
  sezioni.forEach((sezione) => databaseHelper.insertSection(sezione));
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
  //Potrei provare con gli Inherited Widgets molto fighi
  // da quello che so o usando dei provider

  //Al momento quando faccio la select * dal db mi ritorna con l'interfaccia
  //getAll() una lista di sezioni, potrei far ritornare una mappa? o una struttura diversa?
  // Avrebbe senso?
  Future<List<Sezione>> currentData;

  @override
  void initState() {
    super.initState();
    currentData = databaseHelper.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Ho provato ad usare una appBar personalizzata leggermente curva
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.update), onPressed: (){
            setState(() {
              //Update del DB
              currentData = databaseHelper.getAll();
            });
          })
        ],
      ),
      //Per ora corrisponde solo ad un body con una serie di sezioni
      body: buildBody(),
    );
  }

  FutureBuilder<List<Sezione>> buildBody() {
    return FutureBuilder(
      future: currentData, //Necessario per evitare problemi nel caricamento
      builder: (context, snapshot) {
        Widget widgetToShow;
        if (snapshot.hasError) {
          widgetToShow = Text("Errore nell'inizializzazione del DB");
          print(snapshot.error);
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          widgetToShow = ListView(children: [
            for (Sezione s in snapshot.data)
              commons_widgets.genericSection(s)
          ]);
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
            )
          ]);
        }
        return Center(
          child: widgetToShow,
        );
      },
    );
  }
}

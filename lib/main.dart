import 'package:flutter/material.dart';
import '__init__.dart' as commons_widgets;
import 'Provider/db_helper.dart' as DBMS;
import 'package:remote_tree/Model/sezione.dart';

void main() {
  runApp(MyApp());
  initDatabase();
}

DBMS.DatabaseHelper databaseHelper;
void initDatabase() {
  //Simulazione dataset fornito da un DB -> Manca la differenziazione
  // fra le varie tipologie di sezione
  databaseHelper = DBMS.DatabaseHelper();
  databaseHelper.initDb();

  List<Sezione> sezioni = List<Sezione>();
  sezioni.add(Sezione(1, "Informatica", subtitles: ["1", "2", "3", "4"]));
  sezioni.add(Sezione(2, "Analisi I", subtitles: ["5", "6", "7", "8"]));
  sezioni.add(Sezione(3, "Analisi II", subtitles: ["9", "10", "11", "12"]));
  sezioni.add(Sezione(4, "Analisi III", subtitles: ["9", "10", "11", "12"]));
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
  Future<List<Sezione>> currentData;
  @override
  void initState() {
    super.initState();
    currentData = databaseHelper.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      //Ho provato ad usare una appBar personalizzata leggermente curva
      appBar: commons_widgets.generateMyAppBar(widget.title),
      //Per ora corrisponde solo ad un body con una serie di sezioni
      body: buildBody(),
    );
  }

  FutureBuilder<List<Sezione>> buildBody() {
    return FutureBuilder(
      future: currentData, //Necessario per evitare problemi nel caricamento
      builder: (context, snapshot) {
        Widget children;
        if (snapshot.hasError) {
          children = Text("Errore nell'inizializzazione del DB");
          print(snapshot.error);
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          children = ListView(children: [
            for (Sezione s in snapshot.data)
              commons_widgets.genericSection(s)
          ]);
        } else { // Dati non ancora pronti
          children = Column(children: [
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Attesa risultati...'),
            )
          ]);
        }
        return Center(
          child: children,
        );
      },
    );
  }
}

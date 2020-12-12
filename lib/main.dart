import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:remote_tree/Model/Section.dart';

import 'View/HomePage.dart';
import 'Provider/db_helper.dart' as DBMS;
import 'View/DataProvider.dart';
import 'View/SettingsPage.dart';

void main() {
  runApp(MyApp());
  initDatabase();
}

DBMS.DatabaseHelper databaseHelper;

//Inizializzazione del DB
initDatabase() async{
  //Simulazione dataset fornito da un DB -> Manca la differenziazione
  // fra le varie tipologie di sezione
  databaseHelper = DBMS.DatabaseHelper();
  //Inizializzazione DB
  //Parsing json in init -> TODO ogni volta il db viene ri-inizializzato
  String contents = await rootBundle.loadString('assets/sezioniDiBase.json');
  var listSections = ListSection.fromJson(contents);
  //TODO
  //Inserimento sezioni
  databaseHelper.initDb();
  databaseHelper.insertCompleteSection(listSections);
  print("Sezioni inserite");
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DataProvider(
      databaseHelper: databaseHelper,
      child: MaterialApp(
          title: 'Remote Tree',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xFF023e8a),
            backgroundColor: Color(0xFFADE8F4),
            buttonColor: Color(0xFF0077B6),
            cardColor: Color(0xFF00B4D8),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: {
              "/home" : (context) => HomePage(),
              "/settings" : (context) => SettingsPage(),
          },
          home: HomePage(),
        ),
    );
  }
}

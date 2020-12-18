import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:remote_tree/Model/Section.dart';
import 'package:remote_tree/View/LoginPage.dart';
import 'package:remote_tree/View/PDFSectionPage.dart';

import 'Provider/db_helper.dart' as DBMS;
import 'View/DataProvider.dart';
import 'View/HomePage.dart';
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
  String contents = await rootBundle.loadString('assets/sezioniDiBase.json');
  var listSections = ListSection.fromJson(contents);
  //Inserimento sezioni
  databaseHelper.initDb();

  databaseHelper.getCurrentData().then((value) {
    //DB vuoto
    if (value == null){
      databaseHelper.insertCompleteSection(listSections);
    }
    //Asset e db differiscono mi baso sull'asset
    else if (value != listSections){
      databaseHelper.insertCompleteSection(listSections);
    }
    //arrivato qui il db è già pieno
    print("Sezioni inserite");
  });

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
          home: LoginPage(),
        ),
    );
  }
}

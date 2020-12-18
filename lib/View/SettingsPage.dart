import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("In questo momento la app fa quanto richiesto. \n In questa page"
            " si gestirebbe utente - tema scuro - cambio json di riferimento (al momento impossibile)",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
      ),
    );
  }
}

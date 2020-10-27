import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '__init__.dart' as commons_widgets;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  Map<String, List<String>> dataTest = {"Informatica":["Vai alla prima lezione 1", "2", "3", "4"],
  "Matematica 1":["Vai alla prima lezione 1", "2", "3", "4"], "Matematica 2":["Vai alla prima lezione 1", "2", "3", "4"]};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(itemCount: dataTest.keys.length ,itemBuilder: (context, index) {
        var currentElementKey = dataTest.keys.toList()[index];
        var element = dataTest[currentElementKey];
        return commons_widgets.genericSection(currentElementKey, element);
      })
    );
  }
}

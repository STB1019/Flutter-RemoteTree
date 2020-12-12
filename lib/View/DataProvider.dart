import 'package:flutter/material.dart';
import 'package:remote_tree/Provider/db_helper.dart' as DBMS;

class DataProvider extends InheritedWidget{
  final DBMS.DatabaseHelper databaseHelper;
  DataProvider({this.databaseHelper, Widget child}): super(child: child);

  @override
  bool updateShouldNotify(DataProvider oldWidget) {
    return oldWidget.databaseHelper != this.databaseHelper;
  }
  static DataProvider of(BuildContext context)
  => context.dependOnInheritedWidgetOfExactType<DataProvider>();

}
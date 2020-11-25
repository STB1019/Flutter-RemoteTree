import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:remote_tree/Model/Section.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper._();

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  static Database _db;

  String _tableName = "ListaSezioni";
  String _dbName = "main.db";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + _dbName;
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, value TEXT)");
    print("Table creata");
  }

//Da ridefinire per inserire l'intera lista
  Future<int> insertCompleteSection(ListSection listSection) async {
    var dbInstance = await db; //Sto usando il getter
    int res = await dbInstance.insert(_tableName, listSection.toSQL(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Map<String, dynamic>>> _query() async{
    var dbInstance = await db;//Sto usando il getter
    List<Map> res = await dbInstance.query(_tableName);
    return res;
 }
 //I
 Future<ListSection> getCurrentData() async{
    var res = await _query();
    var result = res.first;
    return ListSection.fromSQL(result);
 }

}
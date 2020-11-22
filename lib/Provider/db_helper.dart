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

  String _tableName = "Sezione";
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
        "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, title TEXT, subtitle TEXT)");
    print("Table creata");
  }
//Da ridefinire per inserire l'intera lista
  Future<int> insertSection(GenericSection sezione) async {
    var dbInstance = await db; //Sto usando il getter
    int res = await dbInstance.insert(_tableName, sezione.toSQL(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Map>> _query() async{
    var dbInstance = await db;//Sto usando il getter
    List<Map> res = await dbInstance.query(_tableName);
    return res;
 }
//Da ridefinire per ottenere l'intera lista
 Future<List<GenericSection>> getAll() async{
    var res = await _query();
    List<GenericSection> result = List<GenericSection>();
    res.forEach((e) {
      result.add(GenericSection.generateClassfromJson(e));
    });
    return result;
 }

}
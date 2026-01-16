import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/redacteur.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'redacteurs.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redacteurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            email TEXT,
            age INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    return await db.insert('redacteurs', redacteur.toMap());
  }

  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('redacteurs');
    return List.generate(maps.length, (i) {
      return Redacteur.fromMap(maps[i]);
    });
  }

  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await database;
    return await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return await db.delete('redacteurs', where: 'id = ?', whereArgs: [id]);
  }

  Future<Redacteur?> getRedacteurById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Redacteur.fromMap(maps.first);
    }
    return null;
  }
}

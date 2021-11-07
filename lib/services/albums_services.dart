import 'package:mutfak/models/Dog.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbUtils {
  static final DbUtils _dbUtils = DbUtils._internal();
  DbUtils._internal();

  factory DbUtils() {
    return _dbUtils;
  }

  static Database _db;
  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String path = join(await getDatabasesPath(), 'doggie_database.db');
    var dbDogs = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbDogs;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)");
  }

  Future<void> deleteTable() async {
    final Database db = await this.db;
    db.delete('dogs');
  }

  Future<void> insertDog(Dog dog) async {
    final Database db = await this.db;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    final Database db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    final db = await this.db;
    await db.update(
      'dogs',
      dog.toMap(),
      where: "id = ?",
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    final db = await this.db;
    await db.delete(
      'dogs',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

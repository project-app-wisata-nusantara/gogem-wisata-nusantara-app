import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:gogem/data/model/destination_model.dart';

class DbHelper {
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await initDb();
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        nama TEXT,
        kategori TEXT,
        kabupatenKota TEXT,
        rating REAL,
        preferensi TEXT,
        linkLokasi TEXT,
        latitude REAL,
        longitude REAL,
        linkGambar TEXT,
        deskripsi TEXT
      )
    ''');
  }

  Future<void> insertFavorite(Destination destination) async {
    final db = await database;
    await db.insert(
      'favorites',
      destination.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final maps = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty;
  }

  Future<List<Destination>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');

    return maps.map((map) => Destination.fromMap(map)).toList();
  }
}

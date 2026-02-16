import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SportsCacheHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'sports_cache.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cache (
            key TEXT PRIMARY KEY,
            value TEXT,
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<void> saveToCache(String key, String value) async {
    final db = await database;
    await db.insert(
      'cache',
      {'key': key, 'value': value, 'timestamp': DateTime.now().millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getFromCache(String key, int ttlSeconds) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      final int timestamp = maps.first['timestamp'];
      final int now = DateTime.now().millisecondsSinceEpoch;
      if (now - timestamp < ttlSeconds * 1000) {
        return maps.first['value'];
      } else {
        await db.delete('cache', where: 'key = ?', whereArgs: [key]);
      }
    }
    return null;
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cita.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService instance = DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final ruta = join(
      await getDatabasesPath(),
      'mi_taller.db',
    );

    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE citas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            servicio TEXT,
            dia TEXT,
            hora TEXT,
            estado TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertarCita(Cita cita) async {
    final db = await database;

    return db.insert(
      'citas',
      cita.toMap(),
    );
  }

  Future<List<Cita>> obtenerCitas() async {
    final db = await database;

    // Las citas más recientes salen primero.
    final resultados = await db.query(
      'citas',
      orderBy: 'id DESC',
    );

    return resultados.map(Cita.fromMap).toList();
  }

  Future<int> actualizarCita(Cita cita) async {
    if (cita.id == null) {
      throw ArgumentError('La cita no tiene ID.');
    }

    final db = await database;

    return db.update(
      'citas',
      cita.toMap(),
      where: 'id = ?',
      whereArgs: [cita.id],
    );
  }

  Future<int> eliminarCita(int id) async {
    final db = await database;

    return db.delete(
      'citas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
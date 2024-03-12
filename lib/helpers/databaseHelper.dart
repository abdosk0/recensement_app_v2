import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/famille.dart';
import '../models/menage.dart';
import '../models/personne.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'recensement_database.db'),
      onCreate: (db, version) {
        _createTables(db);
      },
      version: 1,
    );
  }

  static void _createTables(Database db) async {
    await db.execute(
  'CREATE TABLE Menage(id_menage INTEGER PRIMARY KEY, nom TEXT, adresse TEXT, quartier TEXT, ville TEXT, nombre_familles INTEGER)',
);

    await db.execute(
  'CREATE TABLE Famille(id_famille INTEGER PRIMARY KEY, nom TEXT, menage_id INTEGER, completed INTEGER DEFAULT 0, FOREIGN KEY (menage_id) REFERENCES Menage(id_menage))',
);

    await db.execute(
      'CREATE TABLE Personne(personne_id INTEGER PRIMARY KEY, prenom TEXT, nom TEXT, sexe TEXT, dateDeNaissance TEXT, chefFamille INTEGER, lienParente TEXT, famille_id INTEGER, FOREIGN KEY (famille_id) REFERENCES Famille(id_famille))',
    );
  }

   static Future<void> updateMenage(Menage menage) async {
    final db = await database;
    await db.update(
      'Menage',
      menage.toMap(),
      where: 'id_menage = ?',
      whereArgs: [menage.id_menage],
    );
  }

  static Future<void> updateFamille(Famille famille) async {
    final db = await database;
    await db.update(
      'Famille',
      famille.toMap(),
      where: 'id_famille = ?',
      whereArgs: [famille.id_famille],
    );
  }

  static Future<void> updatePersonne(Personne personne) async {
    final db = await database;
    await db.update(
      'Personne',
      personne.toMap(),
      where: 'personne_id = ?',
      whereArgs: [personne.personne_id],
    );
  }

  static Future<List<Map<String, dynamic>>> _queryAllRows(String table) async {
    final Database db = await database;
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getAllMenages() async {
    return _queryAllRows('Menage');
  }
}

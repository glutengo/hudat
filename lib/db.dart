import 'dart:core';
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:hudat/picture.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> setupDatabase() async {
  // Open the database and store the reference.
  return openDatabase(
    // Set the path to the database
    join(await getDatabasesPath(), 'hudat.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE pictures(filepath TEXT, celebrityData TEXT, timestamp INTEGER)'
      );
    },
    version: 1
  );
}

Future<void> insertPicture(Picture picture, Database db) async {
  return db.insert(
    'pictures',
    picture.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Picture>> getPictures(Database db) async {
  final List<Map<String, dynamic>> maps = await db.query('pictures');
  return List.generate(maps.length, (i) => Picture.fromMap(maps[i]));
}

Future<void> deletePicture(String filepath, Database db) async {
  File picture = File(filepath);
  try {
    await picture.delete();
  } catch (e) {
    log(e.toString());
  }
  await db.delete(
    'pictures',
    where: 'filepath = ?',
    whereArgs: [filepath]
  );
}


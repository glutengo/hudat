import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hudat/db.dart';
import 'package:hudat/history.dart';

var database;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()` can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // get the first available camera of the device
  final camera = (await availableCameras()).first;

  // get the database;
  database = await setupDatabase();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: HistoryScreen(
        database: database,
        camera: camera
      )
    ),
  );
}

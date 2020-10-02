import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';
import 'picture.dart';
import 'display-picture.dart';
import 'api.dart';

// A screen that allows users to take a picture using a given camera.
// source: https://flutter.dev/docs/cookbook/plugins/picture-using-camera
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final Database database;

  const TakePictureScreen({
    Key key,
    @required this.camera,
    @required this.database,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool _processingImage = false;
  String _filepath;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium,
        enableAudio: false);

    // initialize the controller. This returns a Future
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  onButtonPressed() async {
    // Ensure that the camera is initialized.
    await _initializeControllerFuture;

    DateTime now = DateTime.now();

    // Construct the path where the image should be saved using the pattern package
    final path = join(
      // Store the picture in the temp directory
      (await getTemporaryDirectory()).path,
      '$now.png',
    );

    // Attempt to take a picture
    await _controller.takePicture(path);
    // set the processing state so the image is displayed and the spinner becomes visible
    setState(() {
      _processingImage = true;
      _filepath = path;
    });

    var celebrityData = (await findCelebrity(path)).body;

    Picture picture = new Picture(
        filepath: path,
        celebrityData: celebrityData,
        timestamp: now.millisecondsSinceEpoch);
    await insertPicture(picture, widget.database);

    // If the picture was taken, display it on a new screen
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(picture: picture),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete
            if (_processingImage) {
              // if the image is currently being processed
              return Stack(
                children: <Widget>[
                  Image.file(File(_filepath)),
                  Center(child: CircularProgressIndicator())
                ],
              );
            } else {
              // display the camera preview.
              return CameraPreview(_controller);
            }
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () => this.onButtonPressed(),
      ),
    );
  }
}

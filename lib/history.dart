import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hudat/picture-list-item.dart';
import 'package:hudat/take-picture.dart';
import 'package:sqflite/sqflite.dart';
import 'package:camera/camera.dart';

import 'db.dart';
import 'display-picture.dart';
import 'picture.dart';

class HistoryScreen extends StatefulWidget {
  final Database database;
  final CameraDescription camera;

  const HistoryScreen({Key key, @required this.database, @required this.camera})
      : super(key: key);

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List<Picture> _pictures = [];

  @override
  void initState() {
    super.initState();
    _updatePictures();
  }

  _updatePictures() async {
    getPictures(widget.database).then((pictures) {
      setState(() {
        _pictures = pictures;
      });
    });
  }

  _showDeleteDialog(Picture picture) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Picture'),
          content: Text('Do you really want to delete this picture?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Confirm'),
              onPressed: () async {
                await deletePicture(picture.filepath, widget.database);
                _updatePictures();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) => PictureListItem(
              picture: _pictures[index],
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DisplayPictureScreen(picture: _pictures[index]))),
              onDelete: () => this._showDeleteDialog(_pictures[index]),
              color: index % 2 == 0
                  ? Color.fromRGBO(0, 0, 0, 0.0)
                  : Color.fromRGBO(255, 255, 255, 0.05),
            ),
        itemCount: _pictures.length);
  }

  Center buildWelcomeMessage(BuildContext context) {
    return Center(
      child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Hello there! 👋",
                style: TextStyle(fontSize: 32.0),
                textAlign: TextAlign.center,),
              SizedBox(height: 16.0,),
              Text(
                "It seems like you have not taken any pictures yet. Get started by tapping the camera icon!",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,)
            ],
          ))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('hudat'))),
      body: _pictures.length > 0
          ? buildListView(context)
          : buildWelcomeMessage(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TakePictureScreen(
                          camera: widget.camera, database: widget.database)))
              .whenComplete(() => _updatePictures());
        },
      ),
    );
  }
}

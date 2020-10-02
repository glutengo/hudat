import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'picture.dart';

class PictureListItem extends StatelessWidget {
  final Picture picture;
  final Color color;
  final Function onTap;
  final Function onDelete;

  const PictureListItem(
      {Key key,
      @required this.picture,
      this.color = Colors.black,
      this.onTap,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.0,
        alignment: Alignment.centerLeft,
        color: this.color,
        child: InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  width: 100,
                  //color: Colors.black,
                  child: Image.file(File(this.picture.filepath),
                      fit: BoxFit.cover)),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(this.picture.getCelebrityString())),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                          new DateFormat.yMMMd().add_jm().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  this.picture.timestamp)),
                          style: TextStyle(color: Colors.grey)),
                    )
                  ],
                ),
              )),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => this.onDelete(),
              )
            ],
          ),
          onTap: () => this.onTap(),
        ));
  }
}

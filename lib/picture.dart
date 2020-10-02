import 'dart:convert';

class Picture {
  final String filepath;
  final String celebrityData;
  final int timestamp;

  Picture({this.filepath, this.celebrityData, this.timestamp});

  static fromMap(Map<String, dynamic> map) {
    return Picture(
      filepath: map['filepath'],
      celebrityData: map['celebrityData'],
      timestamp: map['timestamp']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filepath': filepath,
      'celebrityData': celebrityData,
      'timestamp': timestamp
    };
  }

  String getCelebrityString() {
    var celebrities = List<dynamic>.from(jsonDecode(celebrityData)['CelebrityFaces']);
    if (celebrities.length > 0) {
      return celebrities.map((c) => c['Name']).join(', ');
    } else {
      return 'No celebrities recognized';
    }
  }
}

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

Future<http.Response> findCelebrity(String filepath) async {
  final base64 = base64Encode(await File(filepath).readAsBytes());
  return http.post(
      'https://z9h6j9ivj0.execute-api.us-east-1.amazonaws.com/prod',
      body: '{"bytes": "' + base64 + '"}',
      headers: {HttpHeaders.contentTypeHeader: 'application/json'});
}

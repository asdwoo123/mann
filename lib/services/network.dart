import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mann/constants.dart';

Future<http.Response> getHttpRequest(String url) async {
  http.Response response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Authorization': apiKey
      });
  return response;
}

Future<http.Response> postHttpRequest(String url, Map<String, dynamic> body) async {
  http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': apiKey
      },
      body: jsonEncode(body));
  return response;
}


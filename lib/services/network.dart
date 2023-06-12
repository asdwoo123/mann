import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mann/models/station.dart';
import 'package:mann/constants.dart';

List<String> dataExtract(List<dynamic> data, String name) {
  List<String> dataList = data.map<String>((station){
      return station[name];
  }).toList();
  Set<String> uniqueSet = dataList.toSet();
  List<String> uniqueList = uniqueSet.toList();
  return uniqueList;
}

List<dynamic> searchStations(List<dynamic> data, String name, String value) {
  return data.where((d) => d[name] == value).toList();
}

int findCategoryIndex(List<dynamic> categories, dynamic current) {
  var index = categories.indexWhere((item) => item == current);
  return index == -1 ? 0 : index;
}

Future<List<dynamic>> getStationList() async {
  http.Response response = await http.get(Uri.parse('$host?search=MANN'));
  return jsonDecode(response.body);
}

Future<Station> getStation(station) async {
  http.Response response = await http.get(Uri.parse('$host/info?id=${station['uuid']}'));
  return Station.fromJson(jsonDecode(response.body));
}

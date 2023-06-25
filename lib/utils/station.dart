import 'dart:convert';

import 'package:mann/constants.dart';
import 'package:mann/services/network.dart';
import 'package:http/http.dart' as http;

List<String> extractDataList(List<dynamic> data, String name) {
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
  http.Response response = await getHttpRequest('$hostName/findStations/$companyName');
  return jsonDecode(response.body)['stations'];
}

Future<Map<String, dynamic>> groupingStations(String selectBranchOffice,
    String selectProjectName, String? selectStationName) async {
  List<dynamic> stations = await getStationList();

  List<String> branchOffices = extractDataList(stations, 'branchOffice');
  stations = searchStations(stations, 'branchOffice',
      branchOffices[findCategoryIndex(branchOffices, selectBranchOffice)]);

  List<String> projectNames = extractDataList(stations, 'projectName');
  stations = searchStations(stations, 'projectName',
      projectNames[findCategoryIndex(projectNames, selectProjectName)]);

  List<String> stationNames = (selectStationName != null) ? extractDataList(stations, 'stationName') : [];
  if (selectStationName != null) {
    stations = searchStations(stations, 'stationName',
        stationNames[findCategoryIndex(stationNames, selectStationName)]);
  }

  return {
    'stations': stations,
    'branchOffices': branchOffices,
    'projectNames': projectNames,
    'stationNames': stationNames,
  };
}

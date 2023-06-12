List<String> dataExtract(List<dynamic> data, String name) {
  List<dynamic> dataList = data.map((station){
    return station[name];
  }).toList();
  dataList = dataList.cast<String>().toList();
  Set<String> uniqueSet = Set.from(dataList);
  List<String> uniqueList = uniqueSet.toList();
  return uniqueList;
}

List<dynamic> searchStations(data, name, value) {
  return data.where((d) => d[name] == value).toList();
}

int findCategoryIndex(categories, current) {
  var index = categories.indexWhere((item) => item == current);
  if (index == -1) {
    index = 0;
  }
  return index;
}

Future<List<dynamic>> getStationList() async {
  http.Response response = await http.get(Uri.parse('$host?search=MANN'));
  List<dynamic> stationList = jsonDecode(response.body);

  return stationList;
}

Future<Station> getStation(station) async {
  var host = 'http://seojuneng.ddns.net';
  http.Response response = await http.get(Uri.parse('$host/info?id=${station['uuid']}'));
  Map<String, dynamic> stationJSON = jsonDecode(response.body);
  return Station.fromJson(stationJSON);
}

List<dynamic> stations = await getStationList();
List<String> branchOffices = dataExtract(stations, 'branchOffice');
stations = searchStations(stations, 'branchOffice',
branchOffices[findCategoryIndex(branchOffices, _selectBranchOffice)]);
List<String> projectNames = dataExtract(stations, 'projectName');
stations = searchStations(stations, 'projectName',
projectNames[findCategoryIndex(projectNames, _selectProjectName)]);
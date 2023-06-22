import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:intl/intl.dart';
import 'package:mann/theme.dart';
import 'package:mann/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mann/widgets/custom_roundbutton.dart';

import '../services/network.dart';
import '../widgets/custom_dropdown.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> _branchOffices = [];
  List<String> _projectNames = [];
  List<String> _stationNames = [];
  String _selectBranchOffice = '';
  String _selectProjectName = '';
  String _selectStationName = '';
  String _uuid = '';
  int _page = 1;
  bool _pageEnd = false;
  String _barcode = '';
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;
  List<DataRow> _rows = [];
  List<DataColumn> _columns = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _barcodeController = TextEditingController();

  void _getStationList() async {
    List<dynamic> stations = await getStationList();
    List<String> branchOffices = extractDataList(stations, 'branchOffice');
    stations = searchStations(stations, 'branchOffice',
        branchOffices[findCategoryIndex(branchOffices, _selectBranchOffice)]);
    List<String> projectNames = extractDataList(stations, 'projectName');
    stations = searchStations(stations, 'projectName',
        projectNames[findCategoryIndex(projectNames, _selectProjectName)]);
    List<String> stationNames = extractDataList(stations, 'stationName');
    stations = searchStations(stations, 'stationName',
        stationNames[findCategoryIndex(stationNames, _selectStationName)]);

    if (stations.isEmpty) return;
    setState(() {
      _branchOffices = branchOffices;
      _projectNames = projectNames;
      _stationNames = stationNames;
      _selectBranchOffice =
      (_selectBranchOffice == '') ? branchOffices[0] : _selectBranchOffice;
      _selectProjectName =
      (_selectProjectName == '') ? projectNames[0] : _selectProjectName;
      _selectStationName =
      (_selectStationName == '') ? stationNames[0] : _selectStationName;
      _uuid = stations[0]['uuid'];
    });
  }

  void _getData() async {
    /*if (_uuid == '') return;
    String searchQuery = '/data?page=${_page.toString()}&barcode=$_barcode&start_period='
        '${_startDate.toString()}&end_period=${_endDate.toString()}';
    String url = '$host$searchQuery&id=$_uuid';
    String res = await http.read(Uri.parse(url));

    if (res == '[]') return;

    var decodedRes = jsonDecode(res);*/

    var dummyData = [];
    for (var i = 1; i < 31; i++) {
      dummyData.add({'time': '2023-06-09', 'no': i, '1': 1, '2': 2, '3': 3});
    }

    var columns = dummyData[0]
        .keys
        .map<DataColumn>((column) => DataColumn(label: Text(column)))
        .toList();

    var rows = dummyData
        .map((value) {
      var parsedTime = DateTime.tryParse(value['time']);
      value['time'] = parsedTime != null
          ? DateFormat('yyyy-MM-dd kk:mm:ss').format(parsedTime)
          : '';
      return value;
    })
        .map((value) =>
        value.values.map<DataCell>((v) {
          var cellValue = v ?? 0;
          return DataCell(Text(cellValue.toString()));
        }).toList())
        .map<DataRow>((cells) => DataRow(cells: cells))
        .toList();

    if (_page > 1) {
      setState(() {
        _rows.addAll(rows);
      });
    } else {
      setState(() {
        _rows = rows;
      });
    }

    setState(() {
      _columns = columns;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _getStationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        controller: _scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                          value: _selectBranchOffice,
                          items: _branchOffices,
                          onChanged: (dynamic value) {
                            setState(() {
                              _selectBranchOffice = value;
                            });
                            _getStationList();
                          }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomDropdown(
                          value: _selectProjectName,
                          items: _projectNames,
                          onChanged: (dynamic value) {
                            setState(() {
                              _selectProjectName = value;
                            });
                            _getStationList();
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                          value: _selectStationName,
                          items: _stationNames,
                          onChanged: (dynamic value) {
                            setState(() {
                              _selectStationName = value;
                            });
                            _getStationList();
                          }),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(child: Text(
                      '${_startDate != null ? DateFormat("MM - dd").format(_startDate!) : '-'}   /   ${_endDate != null ? DateFormat("MM - dd").format(_endDate!) : '-'}',
                      style: const TextStyle(fontSize: 16),
                    )),
                    ElevatedButton(onPressed: () {
                      showCustomDateRangePicker(context,
                          dismissible: true,
                          minimumDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          maximumDate: DateTime.now(),
                          startDate: _startDate,
                          endDate: _endDate,
                          onApplyClick: (start, end) {
                            setState(() {
                              _endDate = end;
                              _startDate = start;
                            });
                          },
                          onCancelClick: () {
                            setState(() {
                              _endDate = null;
                              _startDate = null;
                            });
                          }, backgroundColor: primaryBlue,
                          primaryColor: primaryBlue
                      );
                    }, child: const Text('Choose Date')),

                  ],
                ),
                Row(
                  children: [
                    Container(),
                    const Spacer(),
                    CustomRoundButton(text: 'get Data', onPressed: () {_getData();})
                  ],
                ),
              ],
            ),
          ),
    const SizedBox(height: 20,),
    _columns.isNotEmpty ? Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10)),
    child: SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    scrollDirection: Axis.horizontal,
    child: SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    scrollDirection: Axis.vertical,
    child: DataTable(
    columns: _columns,
    rows: _rows)),
    ),
    ) : Container(),
    ]
    ,
    );
  }
}

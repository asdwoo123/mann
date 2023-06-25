import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:intl/intl.dart';
import 'package:mann/services/network.dart';
import 'package:mann/theme.dart';
import 'package:mann/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mann/utils/station.dart';
import 'package:mann/widgets/custom_roundbutton.dart';

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
  int _page = 0;
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;
  List<DataRow> _rows = [];
  List<DataColumn> _columns = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _barcodeController = TextEditingController();

  void _getStationList() async {
    Map<String, dynamic> stationGroup = await groupingStations(
        _selectBranchOffice, _selectProjectName, _selectStationName);
    List<dynamic> stations = stationGroup['stations'];
    List<String> branchOffices = stationGroup['branchOffices'];
    List<String> projectNames = stationGroup['projectNames'];
    List<String> stationNames = stationGroup['stationNames'];

    if (stations.isEmpty) return;
    setState(() {
      _branchOffices = branchOffices;
      _projectNames = projectNames;
      _stationNames = stationNames;
      _selectBranchOffice =
          branchOffices[findCategoryIndex(branchOffices, _selectBranchOffice)];
      _selectProjectName =
          projectNames[findCategoryIndex(projectNames, _selectProjectName)];
      _selectStationName =
          stationNames[findCategoryIndex(projectNames, _selectStationName)];
      _uuid = stations[0]['uuid'];
    });
  }

  void _getData() async {
    if (_uuid == '') return;
    setState(() {
      _isLoading = true;
    });
    String barcode = _barcodeController.text;
    String searchQuery =
        '/data/save?page=${_page.toString()}&barcode=$barcode&start_period='
        '${_startDate.toString()}&end_period=${_endDate.toString()}';
    String url = '$hostName$searchQuery&id=$_uuid';
    http.Response response = await getHttpRequest(url);
    Map<String, dynamic> decodedRes = jsonDecode(response.body);
    int count = decodedRes['count'];
    List<dynamic> data = decodedRes['data'];

    if (data.isNotEmpty || (count / 30 > _page)) {
      var columns = data[0]
          .keys
          .map<DataColumn>((column) => DataColumn(label: Text(column)))
          .toList();

      var rows = data
          .map((value) {
            var parsedTime = DateTime.tryParse(value['time']);
            value['time'] = parsedTime != null
                ? DateFormat('yyyy-MM-dd kk:mm:ss').format(parsedTime)
                : '';
            return value;
          })
          .map((value) => value.values.map<DataCell>((v) {
                var cellValue = v ?? 0;
                return DataCell(Text(cellValue.toString()));
              }).toList())
          .map<DataRow>((cells) => DataRow(cells: cells))
          .toList();

      _rows.addAll(rows);
      _page = _page + 1;
      _columns = columns;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _getData();
    }
  }

  String _dateRangeFormat(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '-';
    return '${DateFormat("MM - dd").format(startDate)}  /  ${DateFormat("MM - dd").format(endDate)}';
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    _getStationList();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              const SizedBox(
                height: 10,
              ),
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    _dateRangeFormat(_startDate, _endDate),
                    style: const TextStyle(fontSize: 16),
                  )),
                  ElevatedButton(
                      onPressed: () {
                        showCustomDateRangePicker(context,
                            dismissible: true,
                            minimumDate: DateTime.now()
                                .subtract(const Duration(days: 365)),
                            maximumDate: DateTime.now(),
                            startDate: _startDate,
                            endDate: _endDate, onApplyClick: (start, end) {
                          setState(() {
                            _endDate = end;
                            _startDate = start;
                          });
                        }, onCancelClick: () {
                          setState(() {
                            _endDate = null;
                            _startDate = null;
                          });
                        },
                            backgroundColor: primaryBlue,
                            primaryColor: primaryBlue);
                      },
                      child: const Text('Choose Date')),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Barcode',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: _barcodeController,
                    ),
                  ),
                  const Spacer(),
                  CustomRoundButton(
                      text: 'get Data',
                      onPressed: () {
                        setState(() {
                          _page = 0;
                          _rows = [];
                        });
                        _getData();
                      })
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _columns.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: DataTable(columns: _columns, rows: _rows)),
                ),
              )
            : Container(),
      ],
    );
  }
}

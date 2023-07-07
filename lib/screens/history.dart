import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:intl/intl.dart';
import 'package:mann/services/network.dart';
import 'package:mann/theme.dart';
import 'package:mann/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mann/widgets/dropdown_group.dart';

import '../widgets/custom_dropdown.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _uuid = '';
  int _page = 0;
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;
  List<DataRow> _rows = [];
  List<DataColumn> _columns = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _barcodeController = TextEditingController();

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

  void _showDateRangePicker(context) {
    showCustomDateRangePicker(context,
        dismissible: true,
        minimumDate: DateTime.now().subtract(const Duration(days: 365)),
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
    }, backgroundColor: Colors.white, primaryColor: Colors.green);
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
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
        Column(
          children: [
            DropdownGroup(
              onChanged: (List<dynamic> stations) {
                setState(() {
                  _uuid = stations[0]['uuid'];
                });
              },
              projectUntil: false,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      _dateRangeFormat(_startDate, _endDate),
                      style: const TextStyle(fontSize: 16),
                    )),
                FilledButton(
                    onPressed: () {
                      _showDateRangePicker(context);
                    },
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6))),
                    child: const Text('Choose Date')),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: textFieldGrey
                              )
                                ),
                          hintText: 'Barcode',
                        ),
                        controller: _barcodeController,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  FilledButton(
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                      onPressed: () {
                    setState(() {
                      _page = 0;
                      _rows = [];
                    });
                    _getData();
                  }, child: const Text('Search Data'))
                ],
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 20,
          color: dividerGrey,
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

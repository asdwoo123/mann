import 'package:flutter/material.dart';
import 'package:mann/utils/station.dart';
import 'package:mann/widgets/custom_dropdown.dart';

class DropdownGroup extends StatefulWidget {
  const DropdownGroup({
    super.key,
    required this.onChanged,
    required this.projectUntil
  });

  final void Function(List<dynamic>) onChanged;
  final bool projectUntil;

  @override
  State<DropdownGroup> createState() => _DropdownGroupState();
}

class _DropdownGroupState extends State<DropdownGroup> with AutomaticKeepAliveClientMixin {
  List<String> _branchOffices = [];
  List<String> _projectNames = [];
  List<String> _stationNames = [];
  String _selectBranchOffice = '';
  String _selectProjectName = '';
  String _selectStationName = '';

  @override
  bool get wantKeepAlive => true;

  void _getStationList() async {
    List<dynamic> stations = await getStationList();

    List<String> branchOffices = extractDataList(stations, 'branchOffice');
    stations = searchStations(stations, 'branchOffice',
        branchOffices[findCategoryIndex(branchOffices, _selectBranchOffice)]);

    List<String> projectNames = extractDataList(stations, 'projectName');
    stations = searchStations(stations, 'projectName',
        projectNames[findCategoryIndex(projectNames, _selectProjectName)]);

    if (!widget.projectUntil) {
      List<String> stationNames = extractDataList(stations, 'stationName');
      stations = searchStations(stations, 'stationName',
          stationNames[findCategoryIndex(stationNames, _selectStationName)]);
      _stationNames = stationNames;
    }

    setState(() {
      _branchOffices = branchOffices;
      _projectNames = projectNames;
      _selectBranchOffice = _branchOffices.isEmpty ? '' :
      branchOffices[findCategoryIndex(branchOffices, _selectBranchOffice)];
      _selectProjectName = _projectNames.isEmpty ? '' :
      projectNames[findCategoryIndex(projectNames, _selectProjectName)];
      _selectStationName = _stationNames.isEmpty ? '' :
      _stationNames[findCategoryIndex(_stationNames, _selectStationName)];
    });

    widget.onChanged(stations);
  }

  @override
  void initState() {
    super.initState();
    _getStationList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdown(
          items: _branchOffices,
          value: _selectBranchOffice,
          onChanged: (String? value) {
            _selectBranchOffice = value!;
            _getStationList();
          },
        ),
        CustomDropdown(
          items: _projectNames,
          value: _selectProjectName,
          onChanged: (String? value) {
            _selectProjectName = value!;
            _getStationList();
          },
        ),
        (!widget.projectUntil) ?
        CustomDropdown(
          items: _stationNames,
          value: _selectStationName,
          onChanged: (String? value) {
            _selectStationName = value!;
            _getStationList();
          },
        ) : Container(),
      ],
    );
  }
}

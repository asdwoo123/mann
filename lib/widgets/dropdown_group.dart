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

class _DropdownGroupState extends State<DropdownGroup> {
  List<String> _branchOffices = [];
  List<String> _projectNames = [];
  List<String> _stationNames = [];
  String _selectBranchOffice = '';
  String _selectProjectName = '';
  String _selectStationName = '';

  void _getStationList() async {
    List<dynamic> stations = await getStationList();

    List<String> branchOffices = extractDataList(stations, 'branchOffice');
    stations = searchStations(stations, 'branchOffice',
        branchOffices[findCategoryIndex(branchOffices, _selectBranchOffice)]);

    List<String> projectNames = extractDataList(stations, 'projectName');
    stations = searchStations(stations, 'projectName',
        projectNames[findCategoryIndex(projectNames, _selectProjectName)]);

    if (widget.projectUntil == false) {
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
    if (widget.projectUntil) {
      _getStationList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdown(
          items: _branchOffices,
          value: _selectBranchOffice,
          onChanged: (String? value) {
            setState(() {
              _selectBranchOffice = value!;
            });
            _getStationList();
          },
        ),
        CustomDropdown(
          items: _projectNames,
          value: _selectProjectName,
          onChanged: (String? value) {
            setState(() {
              _selectProjectName = value!;
            });
            _getStationList();
          },
        ),
        (!widget.projectUntil) ?
        CustomDropdown(
          items: _stationNames,
          value: _selectStationName,
          onChanged: (String? value) {
            setState(() {
              _selectStationName = value!;
            });
            _getStationList();
          },
        ) : Container(),
      ],
    );
  }
}

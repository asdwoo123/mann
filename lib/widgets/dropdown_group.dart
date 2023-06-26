import 'package:flutter/material.dart';
import 'package:mann/utils/station.dart';
import 'package:mann/widgets/custom_dropdown.dart';

class DropdownGroup extends StatefulWidget {
  const DropdownGroup({
    super.key,
    required this.onChanged,
  });

  final void Function(String) onChanged;

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
  String _uuid = '';

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

    widget.onChanged(_uuid);
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
        CustomDropdown(
          items: _stationNames,
          value: _selectStationName,
          onChanged: (String? value) {
            setState(() {
              _selectStationName = value!;
            });
            _getStationList();
          },
        ),
      ],
    );
  }
}

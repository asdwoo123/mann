import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mann/models/settings.dart';
import 'package:mann/utils/station.dart';
import 'package:mann/widgets/custom_dropdown.dart';
import 'package:mann/widgets/custom_roundbutton.dart';
import 'package:http/http.dart' as http;
import 'package:mann/widgets/custom_settingitem.dart';
import '../services/network.dart';
import '../theme.dart';
import 'package:mann/constants.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<String> _branchOffices = [];
  List<String> _projectNames = [];
  List<String> _stationNames = [];
  String _selectBranchOffice = '';
  String _selectProjectName = '';
  String _selectStationName = '';
  String _uuid = '';
  Settings? _settings;

  void _getStationList() async {

    Map<String, dynamic> stationGroup = await groupingStations(_selectBranchOffice, _selectProjectName, _selectStationName);
    List<dynamic> stations = stationGroup['stations'];
    List<String> branchOffices = stationGroup['branchOffices'];
    List<String> projectNames = stationGroup['projectNames'];
    List<String> stationNames = stationGroup['stationNames'];

    if (stations.isEmpty) return;
    setState(() {
      _branchOffices = branchOffices;
      _projectNames = projectNames;
      _stationNames = stationNames;
      _selectBranchOffice = branchOffices[findCategoryIndex(branchOffices, _selectBranchOffice)];
      _selectProjectName = projectNames[findCategoryIndex(projectNames, _selectProjectName)];
      _selectStationName = stationNames[findCategoryIndex(projectNames, _selectStationName)];
      _uuid = stations[0]['uuid'];
    });
  }

  void _connectStation() async {
    String url = '$hostName/setting/setting?id=$_uuid';
    http.Response res = await getHttpRequest(url);
    Map<String, dynamic> parsed = json.decode(res.body);

    setState(() {
      _settings = Settings.fromJson(parsed);
    });
  }

  void _saveStation() async {
    String url = '$hostName/setting/setting?id=$_uuid';
    http.Response res = await postHttpRequest(url, _settings!.toJson());
    int statusCode = res.statusCode;

  }

  @override
  void initState() {
    _getStationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: ListBody(
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
              Row(children: [
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
                CustomRoundButton(onPressed: _connectStation,
                text: 'Connect',)
              ],),
              const SizedBox(height: 10,),
              (_settings != null) ? Column(
                children: [
                  Row(
                    children: [
                      const Text('IP'),
                      const Spacer(),
                      Text(_settings!.ip, style: const TextStyle(fontSize: 16))
                  ]
                  ),
                  CustomSettingItem(label: 'Project name', controller: _settings!.projectController),
                  CustomSettingItem(label: 'Station name', controller: _settings!.stationController),
                  CustomSettingItem(label: 'PLC IP', controller: _settings!.endpointController),
                  Row(
                    children: [
                      const Text('Camera', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Switch(value: _settings!.camera.active, onChanged: (value) {
                        setState(() {
                          _settings!.camera.active = value;
                        });
                      })
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Pantilt', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Switch(value: _settings!.pantilt.active, onChanged: (value) {
                        setState(() {
                          _settings!.pantilt.active = value;
                        });
                      })
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Remote', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Switch(value: _settings!.remote.active, onChanged: (value) {
                        setState(() {
                          _settings!.remote.active = value;
                        });
                      })
                    ],
                  ),
                  CustomSettingItem(label: 'Start', controller: _settings!.remote.startController),
                  CustomSettingItem(label: 'Reset', controller: _settings!.remote.resetController),
                  CustomSettingItem(label: 'Stop', controller: _settings!.remote.stopController),
                  CustomSettingItem(label: 'Light', controller: _settings!.remote.lightController),
                  Row(
                    children: [
                      const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      const Spacer(),
                      Switch(value: _settings!.save.active, onChanged: (value) {
                        setState(() {
                          _settings!.save.active = value;
                        });
                      })
                    ],
                  ),
                  CustomSettingItem(label: 'Complete', controller: _settings!.save.completeController),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Field',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _settings!.save.fields.add(
                                Field.fromJson(
                                    {'name': '', 'nodeId': ''}));
                          });
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: primaryBlue)),
                        child: const Row(
                          children: <Widget>[
                            Icon(Icons.add),
                            Text('ADD')
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: _settings!.save.fields.map<Widget>((e) {
                      return Column(
                        children: [
                          Row(children: [
                            IconButton(
                                onPressed: () {
                                  var index = _settings!.save.fields
                                      .indexOf(e);
                                  setState(() {
                                    _settings!.save.fields
                                        .removeAt(index);
                                  });
                                },
                                color: Colors.red,
                                icon:
                                const Icon(Icons.remove_circle_outline)),
                            Expanded(child: CustomSettingItem(label: 'Name', controller: e.nameController)),
                          ],),
                          CustomSettingItem(label: 'NodeId', controller: e.nodeIdController),
                        ],
                      );
                    }).toList(),
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Node',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _settings!.node.add(Node.fromJson({
                              'name': '',
                              'nodeId': '',
                              'visible': true
                            }));
                          });
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: primaryBlue)),
                        child: const Row(
                          children: <Widget>[
                            Icon(Icons.add),
                            Text('ADD')
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: _settings!.node.map<Widget>((e) {
                      return Column(
                        children: [
                          Row(children: [
                            IconButton(
                                onPressed: () {
                                  var index = _settings!.node
                                      .indexOf(e);
                                  setState(() {
                                    _settings!.node
                                        .removeAt(index);
                                  });
                                },
                                color: Colors.red,
                                icon:
                                const Icon(Icons.remove_circle_outline)),
                            Expanded(child: CustomSettingItem(label: 'Name', controller: e.nameController)),
                          ],),
                          CustomSettingItem(label: 'NodeId', controller: e.nodeIdController),
                        ],
                      );
                    }).toList(),
                  )
                ],
              ) : Container()
            ],
          ),
        ),
    );
  }
}

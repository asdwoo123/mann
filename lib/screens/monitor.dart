import 'package:flutter/material.dart';
import 'package:mann/services/network.dart';
import 'package:mann/widgets/custom_cardview.dart';
import 'package:mann/widgets/custom_dropdown.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/station.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({Key? key}) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  List<String> _branchOffices = [];
  List<String> _projectNames = [];
  String _selectBranchOffice = '';
  String _selectProjectName = '';
  List<Station> _stations = [];
  List<IO.Socket> _sockets = [];

  void _updateStationConnection(Station station, bool isConnected) {
    if (!mounted) return;
    setState(() {
      station.isConnect = isConnected;
    });
  }

  Future<void> _connectSocket(Station station) async {
    IO.Socket socket = IO.io(
        station.connectIp,
        IO.OptionBuilder()
            .setTransports(['websocket'])
        .disableAutoConnect()
            .build());

    socket.connect();
    _sockets.add(socket);
    socket.onConnect((data) {
      _updateStationConnection(station, true);
    });

    socket.onDisconnect((data) {
      _updateStationConnection(station, false);
    });

    socket.on('init', (data) {
      if (mounted == false) return;
      setState(() {
        station.isCamera = data['isCamera'] ?? station.isCamera;
        station.isRemote = data['isRemote'] ?? station.isRemote;
        station.isPantilt = data['isPantilt'] ?? station.isPantilt;
        station.data = data['data'] ?? station.data;
      });
    });

    socket.on('data', (data) {
      if (mounted == false) return;
      setState(() {
        station.data[data['name']] = data['value'];
      });
    });
  }

  void _getStationList() async {
    for (var socket in _sockets) {
      socket.disconnect();
    }

    setState(() {
      _stations = [];
      _sockets = [];
    });

    Map<String, dynamic> stationGroup = await groupingStations(_selectBranchOffice, _selectProjectName, null);
    List<dynamic> stations = stationGroup['stations'];
    List<String> branchOffices = stationGroup['branchOffices'];
    List<String> projectNames = stationGroup['projectNames'];

    setState(() {
      _branchOffices = branchOffices;
      _projectNames = projectNames;
      _selectBranchOffice = branchOffices[findCategoryIndex(branchOffices, _selectBranchOffice)];
      _selectProjectName = projectNames[findCategoryIndex(projectNames, _selectProjectName)];
    });

    for (var stationJSON in stations) {
      Station station = Station.fromJson(stationJSON);

      setState(() {
        _stations.add(station);
      });

      await _connectSocket(station);
    }
  }

  Future<void> _onRefresh() {
    _getStationList();
    return Future<void>.value();
  }

  @override
  void initState() {
    _getStationList();
    super.initState();
  }

  @override
  void dispose() {
    for (var socket in _sockets) {
      socket.disconnect();
      print('disconnect!');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
            children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            child: Row(
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
          ),
          const SizedBox(height: 20,),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _stations.length,
              itemBuilder: (BuildContext ctx, int idx) {
                var station = _stations[idx];
                return CustomCardView(station: station);
              })
        ]));
  }
}

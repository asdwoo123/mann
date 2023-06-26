import 'package:flutter/material.dart';
import 'package:mann/utils/station.dart';
import 'package:mann/widgets/custom_cardview.dart';
import 'package:mann/widgets/custom_dropdown.dart';
import 'package:mann/widgets/dropdown_group.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/station.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({Key? key}) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final List<Station> _stations = [];
  final List<IO.Socket> _sockets = [];

  void _updateStationConnection(Station station, bool isConnected) {
    if (!mounted) return;
    setState(() {
      station.isConnect = isConnected;
    });
  }

  Future<void> _connectSocket(Station station) async {
    for (var socket in _sockets) {
      socket.disconnect();
    }
    _sockets.clear();

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


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var socket in _sockets) {
      socket.disconnect();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
      DropdownGroup(onChanged: (List<dynamic> stations) async {
        _stations.clear();
        for (var stationJSON in stations) {
          Station station = Station.fromJson(stationJSON);

          setState(() {
            _stations.add(station);
          });

          await _connectSocket(station);
        }
      }, projectUntil: true),
      const SizedBox(height: 20,),
      ListView.builder(
          shrinkWrap: true,
          itemCount: _stations.length,
          itemBuilder: (BuildContext ctx, int idx) {
            var station = _stations[idx];
            return CustomCardView(station: station);
          })
    ]);
  }
}

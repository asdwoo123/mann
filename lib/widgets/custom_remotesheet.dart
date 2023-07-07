import 'package:flutter/material.dart';
import 'package:mann/models/station.dart';

class CustomRemoteSheet extends StatelessWidget {
  final Station station;

  const CustomRemoteSheet({
    super.key,
    required this.station
  });

  void _showRemoteActionSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('start'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Reset'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Stop'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Light'),
                onTap: () {},
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return (station.isRemote)
        ? FilledButton(
      onPressed: () {
        _showRemoteActionSheet(context);
      },
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
          shadowColor: Colors.transparent,
      ),
      child: const Text('Remote'),
    )
        : Container();
  }
}

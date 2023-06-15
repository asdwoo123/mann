import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mann/constants.dart';
import 'package:mann/widgets/custom_roundbutton.dart';

import '../models/user.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({Key? key}) : super(key: key);

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  List<User> _users = [];

  void _getUsers() async {
    var url = '$host/user/all';
    http.Response response = await http.get(Uri.parse(url));
    var decodeData = jsonDecode(response.body);
    var usersJson = decodeData['users'];
    List<User> users = [];
    for (var userJson in usersJson) {
      users.add(User.fromJson(userJson));
    }
    setState(() {
      _users = users;
    });
  }

  void _showDialog() {
    showDialog(context: context,
        builder: (context) {
      return AlertDialog(
        title: const Text('정말 유저의 권한을 변경하시겠습니까?'),
        actions: [
          CustomRoundButton(text: '네', onPressed: _changeAuthority),
          CustomRoundButton(text: '아니요', onPressed: () {
            Navigator.of(context).pop();
          }),
        ],
      );
        });
  }

  void _changeAuthority() {

  }

  Future<void> _onRefresh() {
    _getUsers();
    return Future<void>.value();
  }

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        constraints: const BoxConstraints(
          minHeight: 500
        ),
        child: ListView.builder(shrinkWrap: true, itemCount: _users.length,
            itemBuilder: (BuildContext ctx, int idx) {
          var user = _users[idx];
          return Row(
            children: [
              Text(user.name),
              const Spacer(),
              ElevatedButton(onPressed: _showDialog,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    user.authority == 0 ? Colors.green : Colors.red,
                  ),
                ), child: Text(user.authority == 0 ? 'ON' : 'OFF'),
              ),
            ],
          );
            }),
      )
    );
  }
}

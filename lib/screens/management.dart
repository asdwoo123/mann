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
  User? _selectedUser;

  void _getUsers() async {
    var url = '$hostName/user/all';
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
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              '유저의 권한을 변경할까요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: CustomRoundButton(
                        text: '아니요',
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: CustomRoundButton(
                        text: '변경 하기', onPressed: _changeAuthority),
                  ),
                ],
              )
            ],
          );
        });
  }

  void _changeAuthority() {}

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
          constraints: const BoxConstraints(minHeight: 500),
          child: Column(
            children: [
              const Row(
                children: [
                  Text('유저',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Spacer(),
                  Text('권한',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _users.length,
                  itemBuilder: (BuildContext ctx, int idx) {
                    var user = _users[idx];
                    return Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: _showDialog,
                          style: FilledButton.styleFrom(
                              backgroundColor: user.authority == 0
                                  ? Colors.pink
                                  : Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: Text(user.authority == 0 ? 'OFF' : 'ON'),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ));
  }
}

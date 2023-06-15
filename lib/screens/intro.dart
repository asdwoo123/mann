import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mann/screens/home.dart';
import 'package:mann/sub.dart';
import 'package:mann/widgets/custom_roundbutton.dart';
import 'package:http/http.dart' as http;
import 'package:mann/constants.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _goToNextPage(BuildContext context) async {
    final String name = _nameController.text;
    if (name == '') {
      showToast('이름을 입력해주세요.');
      return;
    }

    String url = '$host/user';
    http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({ 'headOffice': company, 'name': name }));
    if (response.statusCode == 200) {
       _navigateToHomeScreen(context);
    } else if (response.statusCode == 404) {
      showToast('이미 존재하는 이름입니다.');
    }
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Text('이름을 입력해주세요'),
        const SizedBox(height: 16,),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: '이름',
          ),
        ),
              const SizedBox(height: 16,),
              CustomRoundButton(text: '등록', onPressed: () {
                _goToNextPage(context);
              })
        ],
      ),
    ),);
  }
}

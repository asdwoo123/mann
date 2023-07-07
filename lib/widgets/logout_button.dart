import 'package:flutter/material.dart';
import 'package:mann/screens/intro.dart';
import 'package:mann/utils/user.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  void _logout(context) async {
    await logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const IntroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _logout(context);
      },
      child: const Text('Logout', style: TextStyle(
        color: Colors.black87,
        fontSize: 14,
      ),),
    );
  }
}

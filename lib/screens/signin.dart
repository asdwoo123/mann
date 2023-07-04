import 'package:flutter/material.dart';
import 'package:mann/constants.dart';
import 'package:mann/theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100,),
              Image.asset(
                'assets/${companyName}_Logo.png',
                width: 200,
              ),
              const SizedBox(height: 32,),
              const Text('아이디와 비밀번호를 입력하십시오.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 32,),
              TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: textFieldGrey
                        )
                    ),
                    hintText: 'Username',
                  )
              ),
              const SizedBox(height: 16,),
              TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: textFieldGrey
                        )
                    ),
                    hintText: 'Password',
                  )
              ),
              const SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                    onPressed: () {},
                    child: const Text('로그인하기')),
              ),
              const SizedBox(height: 16,),
              const Text('가입 화면으로 이동하기.', style: TextStyle(fontSize: 14),),
            ],
          ),
        ),
      ),
    );
  }
}

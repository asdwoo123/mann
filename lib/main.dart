import 'package:flutter/material.dart';
import 'package:mann/screens/home.dart';
import 'package:mann/screens/signin.dart';
import 'package:mann/screens/signup.dart';
import 'constants.dart';
import 'package:mann/screens/intro.dart';

import 'constants.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.green;
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.colorSeed;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelectionMethod = ColorSelectionMethod.colorSeed;
      colorSelected = ColorSeed.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: companyName,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        fontFamily: 'NotoSansCJKkr',
        colorSchemeSeed: colorSelected.color,
        useMaterial3: useLightMode,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: useMaterial3,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen()
    );
  }
}



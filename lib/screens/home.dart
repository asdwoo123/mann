import 'package:flutter/material.dart';
import 'package:mann/screens/history.dart';
import 'package:mann/screens/monitor.dart';
import 'package:mann/screens/setting.dart';
import 'package:mann/theme.dart';
import 'package:mann/widgets/brightness_button.dart';
import 'package:mann/widgets/colorseed_button.dart';
import 'package:toast/toast.dart';

import '../constants.dart';

const List<Widget> widgetOptions = [
  MonitorScreen(),
  HistoryScreen(),
  SettingScreen()
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.useLightMode,
    required this.useMaterial3,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
  }) : super(key: key);

  final bool useLightMode;
  final bool useMaterial3;
  final ColorSeed colorSelected;
  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function(int value) handleColorSelect;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const double _size = 30;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    ToastContext().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 30,
            child: Image.asset('assets/MANN+HUMMEL_Logo.png')),
        /*actions: [
          BrightnessButton(handleBrightnessChange: widget.handleBrightnessChange),
          ColorSeedButton(handleColorSelect: widget.handleColorSelect, colorSelected: widget.colorSelected)
        ],*/
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: backgroundGrey),
          child: IndexedStack(
            index: _selectedIndex,
            children: widgetOptions,
          ),
        ),
      ),
      bottomNavigationBar:
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black87,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.desktop_windows_sharp, size: _size), label: '모니터링'),
          BottomNavigationBarItem(icon: Icon(Icons.history, size: _size), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.settings, size: _size), label: '설정'),
        ],
        currentIndex: _selectedIndex,
        /*selectedItemColor: Colors.amber[800],*/
        onTap: _onItemTapped,
      ),
    );
  }
}

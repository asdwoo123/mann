import 'package:flutter/material.dart';
import 'package:mann/constants.dart';
import 'package:mann/screens/history.dart';
import 'package:mann/screens/management.dart';
import 'package:mann/screens/monitor.dart';
import 'package:mann/screens/setting.dart';
import 'package:mann/theme.dart';
import 'package:mann/widgets/logout_button.dart';
import 'package:toast/toast.dart';


const List<Widget> widgetOptions = [
  MonitorScreen(),
  HistoryScreen(),
  ManagementPage(),
  SettingScreen()
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 30,
            child: Image.asset('assets/${companyName}_Logo.png')),
        actions: const [
          LogoutButton()
        ],
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
          BottomNavigationBarItem(icon: Icon(Icons.supervisor_account_sharp, size: _size), label: '유저관리'),
          BottomNavigationBarItem(icon: Icon(Icons.settings, size: _size), label: '설정'),
        ],
        currentIndex: _selectedIndex,
        /*selectedItemColor: Colors.amber[800],*/
        onTap: _onItemTapped,
      ),
    );
  }
}

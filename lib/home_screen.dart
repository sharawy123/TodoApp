import 'package:flutter/material.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/tabs/settings/settings_tab.dart';
import 'package:to_do_app/tabs/tasks/tasks_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    TasksTab(),
    SettingsTab(),
  ];
  int currentTappedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: AppTheme.white,
        padding: EdgeInsets.zero,
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: BottomNavigationBar(
            elevation: 0,
            currentIndex: currentTappedIndex,
            onTap: (index) => setState(() {
                  currentTappedIndex = index;
                }),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ]),
      ),
      body: tabs[currentTappedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

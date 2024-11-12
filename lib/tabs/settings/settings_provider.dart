import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsProvider with ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;
  String Lang ='en';

  bool get isDark => themeMode == ThemeMode.dark;

  void ChangeTheme(ThemeMode selectedMode)async{
    themeMode =selectedMode;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('dark', isDark);
    notifyListeners();
  }

  SettingsProvider(){
    loadData();
  }
  void loadData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? savedIsDark=preferences.getBool('dark');
    if(savedIsDark!=null)
      themeMode =savedIsDark? ThemeMode.dark :ThemeMode.light;
    notifyListeners();
  }

}
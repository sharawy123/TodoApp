import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsProvider with ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;
  String LangCode ='en';

  bool get isDark => themeMode == ThemeMode.dark;

  void ChangeTheme(ThemeMode selectedMode)async{
    themeMode =selectedMode;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('dark', isDark);
    notifyListeners();
  }
  void ChangeLang(String selectedLang)async{
    if(selectedLang==LangCode) return;
    LangCode=selectedLang;
    SharedPreferences preferences = await SharedPreferences.getInstance();
   preferences.setString('lang', LangCode);
    notifyListeners();
  }

  SettingsProvider(){
    loadData();
  }
  void loadData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? savedIsDark=preferences.getBool('dark');
    if(savedIsDark!=null) {
      themeMode = savedIsDark ? ThemeMode.dark : ThemeMode.light;

      String? LangIsSaved = preferences.getString('lang');
      LangCode = LangIsSaved!;
    }
    notifyListeners();
  }

}
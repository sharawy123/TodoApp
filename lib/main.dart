import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/home_screen.dart';
Future <void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   await FirebaseFirestore.instance.disableNetwork();//disbale remote fire base...
  runApp(ToDoApp());
}
class ToDoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName:(_)=>HomeScreen(),
      },
      initialRoute: HomeScreen.routeName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

    );
  }
}


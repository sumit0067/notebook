import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notebook/screen/splash.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'NoteBook',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Muli',
      appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        textTheme: TextTheme(
            headline6: TextStyle(color: Color(0xff8b8b8b), fontSize: 18)),
        elevation: 0,
        brightness: Brightness.light,
      ),
      primaryColor: Color((0xFFFF7643)),
      primaryColorLight: Color(0xFFFFECDF),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Color(0xFF757575)),
        bodyText2: TextStyle(color: Color(0xFF757575)),
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}


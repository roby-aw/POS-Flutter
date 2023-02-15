import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_complete_guide/screen/splashscreen.dart';

void main() {
  dotenv.load(fileName: "lib/.env");
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
      ]));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SPlashScreen();
  }
}

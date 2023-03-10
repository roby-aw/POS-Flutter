import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<dynamic>> fecthDataHistory(
    BuildContext context, DateTime date) async {
  date = DateTime(date.year, date.month, date.day, date.hour + 12);
  final times = (date.toLocal().millisecondsSinceEpoch / 1000).ceil();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';
  // print(times);
  var result = await http.get(
      Uri.parse(dotenv.env['BASE_URL'].toString() +
          '/pos/order/history?month=' +
          times.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
  if (result.statusCode == 200) {
    // print(json.decode(result.body)['result']);
    return json.decode(result.body)['result'];
  } else {
    prefs.setString('token', '');
    prefs.setBool('is_login', false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
    return [];
  }
}

// void _toHome(){
//   Navigator.pushReplacement(context, newRoute)
// }

// class HomeNetwork {
//   final Map<String, dynamic> result;
//   final String? message;

//   const HomeNetwork({
//     required this.result,
//     required this.message,
//   });

//   factory HomeNetwork.fromJson(Map<String, dynamic> json) {
//     return HomeNetwork(
//       result: json['result'],
//       message: json['message'],
//     );
//   }
// }

// Future<HomeNetwork> fetchHome() async {
//   final time = (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).ceil();
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('token') ?? '';
//   final response = await http
//       .get(Uri.parse('https://amazonpetindo.com/v1/pos/item'), headers: {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $token',
//   });
//   if (response.statusCode == 200) {
//     return HomeNetwork.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

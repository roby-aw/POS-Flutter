import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderNetwork {
  final Map<String, dynamic> result;
  final String? message;

  const OrderNetwork({
    required this.result,
    required this.message,
  });

  factory OrderNetwork.fromJson(Map<String, dynamic> json) {
    return OrderNetwork(
      result: json['result'],
      message: json['message'],
    );
  }
}

Future<List<dynamic>> sendOrder(
    BuildContext context, Map<String, dynamic> data) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  var result = await http.post(
      Uri.parse(dotenv.env['BASE_URL'].toString() + '/pos/orderitem'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: data);
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

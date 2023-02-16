import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestOrder {
  int totalItem;
  int totalPPN;
  int PPN;
  int totalHarga;
  int totalHargaPPN;
  List<Map> orderItem;

  RequestOrder(
      {required this.totalItem,
      required this.totalPPN,
      required this.PPN,
      required this.totalHarga,
      required this.totalHargaPPN,
      required this.orderItem});
}

void sendOrder(RequestOrder, context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';
  var data = {
    'total_item': RequestOrder.totalItem,
    'price_ppn': RequestOrder.totalPPN,
    'total_price_ppn': RequestOrder.totalHargaPPN,
    'ppn': RequestOrder.PPN,
    'total_price': RequestOrder.totalHarga,
    'order': RequestOrder.orderItem,
  };
  print(data);
  var result = await http.post(
      Uri.parse(dotenv.env['BASE_URL'].toString() + '/pos/orderitem'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data));
  print(result.statusCode);
  print(result.body);
  if (result.statusCode == 200) {
    // print(json.decode(result.body)['result']);
    return json.decode(result.body)['result'];
  }
  // } else {
  //   prefs.setString('token', '');
  //   prefs.setBool('is_login', false);
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => Login()));
  // }
}

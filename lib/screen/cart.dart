import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/splashscreen.dart';
import 'package:flutter_complete_guide/network/dashboard.dart';

class Cart extends StatefulWidget {
  late List<Map<String, dynamic>> cart;
  Cart(this.cart);

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    num total = 0;

    for (var i = 0; i < widget.cart.length; i++) {
      total += widget.cart[i]['price_sell'] * widget.cart[i]['stock'];
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: ListView.builder(
          itemCount: widget.cart.length,
          itemBuilder: (context, index) {
            return ListTile(
              trailing: Container(
                  padding: EdgeInsets.only(top: 10),
                  width: 50,
                  child: Center(
                    child: Text(widget.cart[index]['stock'].toString()),
                  )),
              leading: CircleAvatar(
                  child: Image.memory(
                      base64Decode(widget.cart[index]['image'].split(',')[1]))),
              title: Text(widget.cart[index]['name']),
              subtitle: Text(
                  'price : ' + widget.cart[index]['price_sell'].toString()),
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.blueAccent, width: 1))),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('Total : ' + 'Rp. ' + total.toString()),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () {},
                  child: Text(
                    'Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// class Cart {
//   late List<Map<String, dynamic>> cart;
// }


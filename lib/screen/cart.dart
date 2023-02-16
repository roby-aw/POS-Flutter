import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screen/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/splashscreen.dart';
import 'package:flutter_complete_guide/network/dashboard.dart';
import 'package:flutter_complete_guide/network/order.dart';

class Cart extends StatefulWidget {
  late List<Map<String, dynamic>> cart;
  int ppn;
  Cart(this.cart, this.ppn);

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    int total_item = 0;
    int total = 0;
    List<Map<dynamic, dynamic>> items = [];
    print(widget.cart);
    for (var i = 0; i < widget.cart.length; i++) {
      total_item += widget.cart[i]['stock'] as int;
      var item = {
        'productid': widget.cart[i]['id_item'],
        'qty': widget.cart[i]['stock'],
      };
      items.add(item);
      total += widget.cart[i]['price_sell'] * widget.cart[i]['stock'] as int;
    }
    final total_ppn = total + (total * widget.ppn / 100);

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total : ' + 'Rp. ' + total.toString(),
                        style: TextStyle(color: Colors.blue),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          'PPN : ' + widget.ppn.toString() + '%',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  'Total + PPN : ' + 'Rp. ' + total_ppn.toString(),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Order item'),
                      content: const Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            var reqData = RequestOrder(
                                totalHarga: total,
                                orderItem: items,
                                totalItem: total_item,
                                totalHargaPPN: total,
                                PPN: widget.ppn,
                                totalPPN: (total - total_ppn).round());

                            sendOrder(reqData, context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              (route) => false,
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  // onPressed: () {
                  //   var reqData = RequestOrder(
                  //       totalHarga: total,
                  //       orderItem: items,
                  //       totalItem: total_item,
                  //       totalHargaPPN: total,
                  //       PPN: widget.ppn,
                  //       totalPPN: (total - total_ppn).round());

                  //   sendOrder(reqData, context);
                  // },
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


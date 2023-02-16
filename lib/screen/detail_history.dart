import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/splashscreen.dart';
import 'package:flutter_complete_guide/screen/cart.dart';
import 'package:flutter_complete_guide/screen/dashboard.dart';
import 'package:flutter_complete_guide/network/history.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class Detail_History extends StatefulWidget {
  final List<dynamic> item;
  final String HistoryDate;
  final int PPN;

  const Detail_History(
      {Key? key,
      required this.item,
      required this.HistoryDate,
      required this.PPN})
      : super(key: key);

  @override
  _Detail_HistoryState createState() =>
      _Detail_HistoryState(item, HistoryDate, PPN);
}

class _Detail_HistoryState extends State<Detail_History> {
  final List<dynamic> item;
  final String HistoryDate;
  final int PPN;
  _Detail_HistoryState(this.item, this.HistoryDate, this.PPN);
  int _counter = 1;
  int _selectedIndex = 1;
  Future<List<dynamic>>? data;
  DateTime _selected = DateTime.now();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = item.map((e) => e['price_sell'] * e['qty']).toList();
    final formatter = NumberFormat.simpleCurrency(locale: 'id_ID');
    final list = List<Map<String, dynamic>>.from(item);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blueGrey,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.blue,
        title: Text('Detail_History'),
        actions: [IconButton(onPressed: _LogOut, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: Stack(children: [
          ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: 250,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Image.memory(base64Decode(
                                    list[index]['image'].split(',')[1])),
                              ),
                              title: Text(list[index]['name']),
                              subtitle: Text(
                                  formatter.format(list[index]['price_sell'])),
                            )),
                        Container(
                          width: 90,
                          child: ListTile(
                            title:
                                Text(list[index]['qty'].toString() + ' item'),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      // height: 20,
                      // thickness: 5,
                      // indent: 20,
                      // endIndent: 0,
                      color: Colors.black,
                    ),
                  ],
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // width: double.infinity,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    child: ListTile(
                      title: Text(
                        'Total',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        formatter.format(total.reduce((a, b) => a + b)),
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        'PPN : ' + PPN.toString() + '%',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: ListTile(
                      title: Text(
                        'Date',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMMM yyyy')
                            .format(DateTime.parse(HistoryDate).toLocal()),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Detail_History Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.amber[800],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false);
              _onItemTapped(index);
              break;
          }
        },
      ),
    );
  }

  void _LogOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_login', false);
    await prefs.setString('email', '');
    await prefs.setString('token', '');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SPlashScreen(),
      ),
      (route) => false,
    );
  }
}

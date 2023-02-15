import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/splashscreen.dart';
import 'package:flutter_complete_guide/screen/cart.dart';
import 'package:flutter_complete_guide/screen/dashboard.dart';
import 'package:flutter_complete_guide/network/history.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final List<Map<String, dynamic>> cart = [];
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
  void initState() {
    super.initState();
    data = fecthDataHistory(context, _selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blueGrey,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.blue,
        title: Text('History'),
        actions: [
          IconButton(
              onPressed: () {
                _onPressed(context: context, locale: 'id');
              },
              icon: Icon(Icons.date_range)),
          IconButton(onPressed: _LogOut, icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
          child: FutureBuilder<List<dynamic>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    trailing: Text(
                        snapshot.data![index]['total_item'].toString() +
                            ' item'),
                    title: Text(snapshot.data?[index]['transactionid']),
                    subtitle: Text(DateFormat.yMd().add_jm().format(
                        DateTime.parse(snapshot.data?[index]['created_at']))),
                  ));
                  // return Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: <Widget>[
                  //     ListView.builder(
                  //       physics: ClampingScrollPhysics(),
                  //       shrinkWrap: true,
                  //       itemCount: snapshot.data?[index]['item'].length,
                  //       itemBuilder: (BuildContext context, indexs) =>
                  //           Container(
                  //         child: Text(
                  //             snapshot.data?[index]['item'][indexs]['name']),
                  //       ),
                  //     )
                  //   ],
                  // );
                  //   print(snapshot.data);
                  //   return ListTile(
                  //     title: Text(snapshot.data?[index]['transactionid']),
                  //     onTap: () {
                  //       print(snapshot.data);
                  //       print(snapshot.data?[index]['transactionid']);
                  //       // if (snapshot.data?[index]['stock'] > 0) {
                  //       //   _incrementCounter();
                  //       //   setState(() {
                  //       //     snapshot.data?[index]['stock'] -= 1;
                  //       //   });
                  //       //   bool isExist = false;
                  //       //   cart.forEach((element) {
                  //       //     if (element['id_item'] ==
                  //       //         snapshot.data?[index]['id']) {
                  //       //       isExist = true;
                  //       //     }
                  //       //   });

                  //       //   if (isExist) {
                  //       //     cart.forEach((element) {
                  //       //       if (element['id_item'] ==
                  //       //           snapshot.data?[index]['id']) {
                  //       //         element['stock'] += 1;
                  //       //       }
                  //       //     });
                  //       //   } else {
                  //       //     cart.add({
                  //       //       'id_item': snapshot.data?[index]['id'],
                  //       //       'stock': 1,
                  //       //       'price_sell': snapshot.data?[index]['price_sell'],
                  //       //       'name': snapshot.data?[index]['name'],
                  //       //       'image': snapshot.data?[index]['image']
                  //       //     });
                  //       //   }
                  //       // } else {
                  //       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //       //     content: Text(
                  //       //       'Stock Habis',
                  //       //       style: TextStyle(color: Colors.red),
                  //       //     ),
                  //       //     duration: Duration(seconds: 2),
                  //       //   ));
                  //       // }
                  //     },
                  //     trailing: Container(
                  //         padding: EdgeInsets.only(top: 10),
                  //         width: 50,
                  //         child: Column(children: [
                  //           // Text(snapshot.data?[index]['price_sell'].toString() ??
                  //           //     ""),
                  //           // if (snapshot.data?[index]['stock'] < 10)
                  //           //   Text(
                  //           //     snapshot.data?[index]['stock'].toString() ?? "",
                  //           //     style: TextStyle(color: Colors.red),
                  //           //   )
                  //           // else
                  //           //   Text(
                  //           //     snapshot.data?[index]['stock'].toString() ?? "",
                  //           //     style: TextStyle(color: Colors.green),
                  //           //   )
                  //         ])),
                  //     // title: Text(snapshot.data?[index]['name']),
                  //     // leading: CircleAvatar(
                  //     //     child: Image.memory(base64Decode(
                  //     //         snapshot.data?[index]['image'].split(',')[1]))),
                  //   );
                });
          } else {
            return Center(child: Text('No selected month for history'));
          }
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History Order',
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

  Future<void> _onPressed({
    required BuildContext context,
    String? locale,
  }) async {
    int year = DateTime.now().toUtc().year;
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
        context: context,
        initialDate: _selected ?? DateTime.now(),
        firstDate: DateTime(year - 4),
        lastDate: DateTime(year + 4),
        locale: localeObj);
    if (selected != null) {
      setState(() {
        _selected = selected;
      });
    }
    setState(() {
      data = fecthDataHistory(context, _selected);
    });
  }
}

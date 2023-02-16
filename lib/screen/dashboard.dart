import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/screen/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/splashscreen.dart';
import 'package:flutter_complete_guide/screen/cart.dart';
import 'package:flutter_complete_guide/network/dashboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> cart = [];
  int _counter = 0;
  int _selectedIndex = 0;
  Future<List<dynamic>>? data;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    data = fecthDataUsers(context);
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
        title: Text('Home'),
        actions: [IconButton(onPressed: _LogOut, icon: Icon(Icons.logout))],
      ),
      body: RefreshIndicator(
          onRefresh: () => fecthDataUsers(context),
          child: Center(
              child: FutureBuilder<List<dynamic>>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Card(
                          color: Colors.blue[100],
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            onTap: () {
                              if (snapshot.data?[index]['stock'] > 0) {
                                _incrementCounter();
                                setState(() {
                                  snapshot.data?[index]['stock'] -= 1;
                                });
                                bool isExist = false;
                                cart.forEach((element) {
                                  if (element['id_item'] ==
                                      snapshot.data?[index]['id']) {
                                    isExist = true;
                                  }
                                });

                                if (isExist) {
                                  cart.forEach((element) {
                                    if (element['id_item'] ==
                                        snapshot.data?[index]['id']) {
                                      element['stock'] += 1;
                                    }
                                  });
                                } else {
                                  cart.add({
                                    'id_item': snapshot.data?[index]['id'],
                                    'stock': 1,
                                    'price_sell': snapshot.data?[index]
                                        ['price_sell'],
                                    'name': snapshot.data?[index]['name'],
                                    'image': snapshot.data?[index]['image']
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Stock Habis',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            },
                            trailing: Container(
                                padding: EdgeInsets.only(top: 10),
                                width: 100,
                                height: 100,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Rp. ' +
                                                snapshot.data![index]
                                                        ['price_sell']
                                                    .toString(),
                                          ),
                                          if (snapshot.data![index]['stock'] <
                                              10)
                                            Text(
                                              snapshot.data![index]['stock']
                                                      .toString() +
                                                  " Stock",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          else
                                            Text(
                                              snapshot.data![index]['stock']
                                                      .toString() +
                                                  " Stock",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                        ]))),
                            title: Text(snapshot.data?[index]['name']),
                            leading: CircleAvatar(
                                child: Image.memory(base64Decode(snapshot
                                    .data?[index]['image']
                                    .split(',')[1]))),
                          ));
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ))),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(cart);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Cart(cart)));
          },
          tooltip: 'Increment',
          child: Container(
              width: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart),
                    Text(_counter.toString())
                  ]))),
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
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => History()),
                (route) => false,
              );
              _onItemTapped(index);
              break;
          }
        },
      ),
    );
  }

  void _CheckData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('is_login') ?? false;
    final String? email = prefs.getString('email');
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}

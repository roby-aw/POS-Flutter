import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/splashscreen.dart';
import 'package:flutter_complete_guide/network/dashboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> cart = [];
  int _counter = 0;
  Future<List<dynamic>>? data;

  @override
  void initState() {
    super.initState();
    data = fecthDataUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Home'),
        actions: [IconButton(onPressed: _LogOut, icon: Icon(Icons.logout))],
      ),
      body: Center(
          child: FutureBuilder<List<dynamic>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      bool isExist = false;
                      cart.forEach((element) {
                        if (element['id_item'] == snapshot.data?[index]['id']) {
                          isExist = true;
                        } else {
                          isExist = false;
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
                        });
                      }

                      if (snapshot.data?[index]['stock'] > 0) {
                        _incrementCounter();
                        setState(() {
                          snapshot.data?[index]['stock'] -= 1;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                        width: 50,
                        child: Column(children: [
                          Text(snapshot.data?[index]['price_sell'].toString() ??
                              ""),
                          if (snapshot.data?[index]['stock'] < 10)
                            Text(
                              snapshot.data?[index]['stock'].toString() ?? "",
                              style: TextStyle(color: Colors.red),
                            )
                          else
                            Text(
                              snapshot.data?[index]['stock'].toString() ?? "",
                              style: TextStyle(color: Colors.green),
                            )
                        ])),
                    title: Text(snapshot.data?[index]['name']),
                    leading: CircleAvatar(
                        child: Image.memory(base64Decode(
                            snapshot.data?[index]['image'].split(',')[1]))),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _incrementCounter();
            print(cart);
          },
          tooltip: 'Increment',
          child: Container(
              width: 50,
              child: Row(children: [
                Icon(Icons.shopping_cart),
                Text(_counter.toString())
              ]))),
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

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/images/chatnews.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}

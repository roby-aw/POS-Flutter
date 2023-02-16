import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/dashboard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _email = TextEditingController();
  var _password = TextEditingController();

  String _message = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: TextButton(
              onPressed: () {},
              child: Text(
                'Chatnews',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 500,
                width: 500,
                child: Column(children: [
                  Image(
                    image: Image.asset('assets/images/image_pos.jpg').image,
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      // autofocus: true,
                      controller: _email,
                      onFieldSubmitted: (value) {
                        if (_email.text.isEmpty) {
                          _showEmptyDialog('Email');
                        } else if (_password.text.isEmpty) {
                          _showEmptyDialog('Password');
                        } else if (_email.text.length < 8) {
                          _showLenght8Dialog('Email');
                        } else if (_password.text.length < 8) {
                          _showLenght8Dialog('Password');
                        } else {
                          doLogin(_email.text, _password.text);
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Masukkan Email',
                        icon: Icon(Icons.email),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      obscureText: true,
                      onFieldSubmitted: (value) {
                        if (_email.text.isEmpty) {
                          _showEmptyDialog('Email');
                        } else if (_password.text.isEmpty) {
                          _showEmptyDialog('Password');
                        } else if (_email.text.length < 8) {
                          _showLenght8Dialog('Email');
                        } else if (_password.text.length < 8) {
                          _showLenght8Dialog('Password');
                        } else {
                          doLogin(_email.text, _password.text);
                        }
                      },
                      controller: _password,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Masukkan Password',
                        icon: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 245)),
                      ElevatedButton(
                          style: ButtonStyle(alignment: Alignment.center),
                          onPressed: () {
                            if (_email.text.isEmpty) {
                              _showEmptyDialog('Email');
                            } else if (_password.text.isEmpty) {
                              _showEmptyDialog('Password');
                            } else if (_email.text.length < 8) {
                              _showLenght8Dialog('Email');
                            } else if (_password.text.length < 8) {
                              _showLenght8Dialog('Password');
                            } else {
                              doLogin(_email.text, _password.text);
                            }
                          },
                          child: Icon(Icons.login)),
                    ],
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  // create alert dialog
  void _showEmptyDialog(String field) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('$field is empty'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  void _showLenght8Dialog(String field) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('$field harus lebih dari 8 karakter'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  doLogin(String email, String password) async {
    var url = Uri.parse(dotenv.env['BASE_URL'].toString() + '/account/login');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    var result = jsonDecode(response.body);
    _message = result['message'];
    print(response.body);
    if (response.statusCode == 200) {
      print('success');
      print(result['result']['token']['access_token']);
      _showMessageDialog(_message);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', result['result']['token']['access_token']);
      await prefs.setString('email', result['result']['email']);
      await prefs.setBool('is_login', true);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
        (route) => false,
      );
    } else {
      _showMessageDialog(_message);
    }
  }
}

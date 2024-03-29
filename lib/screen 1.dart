import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final formKey = GlobalKey<FormState>();

  bool _isObscure = true;

  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();

  // Method to set user ID in shared preferences
  Future<void> _setUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  // Method to get user ID from shared preferences
  Future<int?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> login() async {
    String apiUrl = 'http://92.205.109.210:8055/Login/UserLogin';
    String name = username.text;
    String password = pass.text;
    Map<String, String> requestData = {'UserName': name, 'Password': password};

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestData),
      );
      print(apiUrl);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData); // Print response for debugging
        if (responseData.containsKey('msg') &&
            responseData['msg'] ==
                'Please Enter Valid User Name OR Password') {
          // Show error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(responseData['msg']),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Successful login
          int userId = responseData['userId'];
          // Save user ID in shared preferences
          await _setUserId(userId);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Screen2()),
          );
        }
      } else {
        // Handle other error cases
        // Show an error message or do something else
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            "Kanyaa Residency",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.only(right: 300),
                child: Text(
                  "Welcome,",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(right: 230),
                child: Text(
                  "Username",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: username,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value) {},
                  validator: (name) =>
                  name!.length < 3 ? "Name should be at least 3 characters" : null,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 230),
                child: Text(
                  "Password",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: pass,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Minimum 8 characters";
                    }
                  },
                  obscureText: _isObscure,
                ),
              ),
              SizedBox(height: 40),
              Container(
                height: 60,
                width: 300,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange,
                     Colors.orange,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange,
                      spreadRadius: 7,
                      blurRadius: 20,
                      offset: Offset(1,1),
                    )
                  ],
                ),
                child: ElevatedButton(
                  onPressed: (){
                    login();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kanya/screen%201.dart';
import 'package:kanya/screen4.1.dart';
import 'package:kanya/screen5.dart';
import 'package:kanya/screen6.dart';
import 'bookscreenclass.dart';

class Screen4 extends StatefulWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();

  final _formkey = GlobalKey<FormState>();


  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      _selectTime(controller, picked);
    }
  }

  Future<void> _selectTime(
      TextEditingController controller, DateTime selectedDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          picked.hour,
          picked.minute,
        );
        controller.text = selectedDateTime.toString();
      });
    }
  }

  bool visibilty=false;
  String checkin="";
  String checkout="";

  Future<List<AvailRoomsByDate>> addcat(String checkin, String checkout) async {
    var result = await http.post(Uri.parse("http://92.205.109.210:8055/Booking/GetAvailRoomsByDate"),
        headers: <String, String>{
          'Content-Type':'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, dynamic>{
          "CheckInDateTime": checkin,
          "CheckOutDateTime": checkout,
        })
    );
    var data = jsonDecode(result.body)["availRoomsByDate"];
    print(data.toString()+"data");
    return (data as List).map((e) => AvailRoomsByDate.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Room Availability",
            style: TextStyle(color: Colors.white),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
              color: Colors.white,
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.cyanAccent,
          child: Container(
            color: Colors.black,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 80,
                ),
                ListTile(
                  leading: Icon(
                    Icons.room_preferences_sharp,
                    color: Colors.white,
                  ),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => screen5()),
                      );
                    },
                    child: const Text(
                      'Rooms Master',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Icon(
                    Icons.book_online_rounded,
                    color: Colors.white,
                  ),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Screen6()),
                      );
                    },
                    child: const Text(
                      'View BookScreen',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Icon(
                    Icons.report,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Reports',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    showLogoutConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Text(
                          "From Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 250,
                    height: 100,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _fromDateController,
                      onTap: () => _selectDate(_fromDateController),
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Tap to select date and time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date';
                        }
                        return null; // Return null if the entered value is valid
                      },
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Text(
                          "To Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 250,
                    height: 100,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _toDateController,
                      onTap: () => _selectDate(_toDateController),
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Tap to select date and time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date';
                        }
                        return null; // Return null if the entered value is valid
                      },
                    )

                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(_formkey.currentState!.validate()){
                        setState(() {
                          visibilty = true;
                          checkin=_fromDateController.text;
                          checkout=_toDateController.text;
                        });
                      }
                    },
                    child: Text("Search"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  visibilty ? Container(
                    width: 300,
                    height: 350,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white)
                    ),
                     child:FutureBuilder<List<AvailRoomsByDate>>(
                       future: addcat(checkin, checkout),
                       builder: (context, snapshot) {
                         if (snapshot.connectionState == ConnectionState.waiting) {
                           return CircularProgressIndicator();
                         } else if (snapshot.hasError) {
                           return Text('Error: ${snapshot.error}');
                         } else {
                           List<AvailRoomsByDate> list = snapshot.data!;
                           return Column(
                             children: [
                               Expanded(
                                 child: ListView.builder(
                                   itemCount: list.length,
                                   itemBuilder: (BuildContext context, int index) {
                                     return Column(
                                       children: [
                                         ListTile(
                                           leading: Text(
                                             'Room No: ${list[index].roomNo}',
                                             style: TextStyle(color: Colors.white),
                                           ),
                                           title: Text(
                                             'Price: ${list[index].price}',
                                             style: TextStyle(color: Colors.white),
                                           ),
                                         ),
                                         Divider(
                                           color: Colors.white, // Set the color of the divider
                                           thickness: 1.0, // Set the thickness of the divider
                                         ),
                                       ],
                                     );

                                   },
                                 ),
                               ),
                             ],
                           );
                         }
                       },
                     ),


                  ): SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                // Perform logout operation here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen1()),
                );
                // Pop back to the previous screen
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
